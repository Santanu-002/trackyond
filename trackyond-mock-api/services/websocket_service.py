import asyncio
import logging
import threading
import time
import json
from datetime import datetime, timezone
from core.utils.datetime_utils import now_utc, to_utc_iso
from typing import Dict, List, Optional
from fastapi import WebSocket, WebSocketDisconnect
from sqlalchemy.orm import Session

from db.database import SessionLocal
from db import models
from services.token_service import token_service
from services import job_chat_service
from schemas import job_chat as schemas

logger = logging.getLogger("websocket_service")

class WebSocketConnectionManager:
    """
    Thread-safe manager for WebSocket connections.
    """
    def __init__(self):
        # Maps user_uid -> list of active connections.
        # Each connection is represented by a dict:
        # {
        #   "websocket": WebSocket,
        #   "exp": int, # Access token expiration timestamp
        #   "phone": str,
        #   "device_id": str,
        #   "last_heartbeat": float
        # }
        self.active_connections: Dict[str, List[dict]] = {}
        self._lock = threading.Lock()
        self._loop_task: Optional[asyncio.Task] = None

    def start_monitoring(self):
        """Start the background task to monitor token expiration."""
        self._loop_task = asyncio.create_task(self._monitor_token_expiration())
        logger.info("WebSocket token expiration monitor background loop started.")

    async def stop_monitoring(self):
        """Stop the background task."""
        if self._loop_task:
            self._loop_task.cancel()
            try:
                await self._loop_task
            except asyncio.CancelledError:
                pass
            logger.info("WebSocket token expiration monitor background loop stopped.")

    def connect(self, websocket: WebSocket, user_uid: str, phone: str, device_id: str, exp_time: int):
        with self._lock:
            if user_uid not in self.active_connections:
                self.active_connections[user_uid] = []
            self.active_connections[user_uid].append({
                "websocket": websocket,
                "exp": exp_time,
                "phone": phone,
                "device_id": device_id,
                "last_heartbeat": time.time()
            })
            logger.info(f"WebSocket connected: user_uid={user_uid}, device_id={device_id}. Active users: {len(self.active_connections)}")

    def disconnect(self, user_uid: str, websocket: WebSocket):
        with self._lock:
            if user_uid in self.active_connections:
                self.active_connections[user_uid] = [
                    conn for conn in self.active_connections[user_uid] if conn["websocket"] != websocket
                ]
                if not self.active_connections[user_uid]:
                    del self.active_connections[user_uid]
            logger.info(f"WebSocket disconnected: user_uid={user_uid}. Active users: {len(self.active_connections)}")

    async def send_personal_message(self, message: dict, websocket: WebSocket):
        try:
            await websocket.send_json(message)
        except Exception as e:
            logger.warning(f"Error sending message over WebSocket: {e}")

    async def broadcast_to_user(self, user_uid: str, message: dict):
        connections_to_send = []
        with self._lock:
            if user_uid in self.active_connections:
                connections_to_send = list(self.active_connections[user_uid])
        
        for conn in connections_to_send:
            await self.send_personal_message(message, conn["websocket"])

    async def broadcast_to_job(self, db: Session, job_id: str, event: str, type: str, data: dict):
        job = db.query(models.Job).filter(models.Job.job_id == job_id).first()
        if not job:
            logger.warning(f"Job {job_id} not found for websocket broadcast.")
            return

        profile_uids = []
        if job.created_by_profile_uid:
            profile_uids.append(job.created_by_profile_uid)
        if job.worker_profile_uid:
            profile_uids.append(job.worker_profile_uid)

        if not profile_uids:
            return

        members = db.query(models.Member).filter(models.Member.uid.in_(profile_uids)).all()
        user_uids = {m.user_uid for m in members if m.user_uid}

        payload = {
            "event": event,
            "type": type,
            "headers": {},
            "data": data
        }

        for user_uid in user_uids:
            await self.broadcast_to_user(user_uid, payload)

    async def _monitor_token_expiration(self):
        while True:
            try:
                await asyncio.sleep(30)
                now_ts = now_utc().timestamp()
                renewals = []

                # Thread-safe identification of connections nearing expiration (within 2 minutes)
                with self._lock:
                    for user_uid, connections in list(self.active_connections.items()):
                        for conn in connections:
                            if conn["exp"] - now_ts <= 120:
                                try:
                                    new_tokens = token_service.generate_tokens(user_uid, conn["phone"])
                                    payload = token_service.decode_token(new_tokens["accessToken"], "access")
                                    new_exp = payload["exp"]
                                    renewals.append((user_uid, conn["websocket"], new_tokens, new_exp))
                                except Exception as e:
                                    logger.error(f"Failed to generate renewal tokens for {user_uid}: {e}")

                # Send renewal messages outside the lock
                for user_uid, websocket, new_tokens, new_exp in renewals:
                    renewal_frame = {
                        "event": "system",
                        "type": "tokenRenewal",
                        "headers": {},
                        "data": new_tokens
                    }
                    await self.send_personal_message(renewal_frame, websocket)

                    # Update the exp timestamp locally under lock
                    with self._lock:
                        if user_uid in self.active_connections:
                            for conn in self.active_connections[user_uid]:
                                if conn["websocket"] == websocket:
                                    conn["exp"] = new_exp
                                    logger.info(f"Successfully renewed and updated token expiration for user_uid={user_uid}")
                                    break
            except asyncio.CancelledError:
                break
            except Exception as e:
                logger.error(f"Error in token renewal monitor background loop: {e}", exc_info=True)

    async def handle_message(self, websocket: WebSocket, user_uid: str, data_text: str):
        try:
            frame = json.loads(data_text)
        except Exception as e:
            logger.warning(f"Malformed JSON frame received from user_uid={user_uid}: {e}")
            await self.send_personal_message({
                "event": "system",
                "type": "error",
                "headers": {},
                "data": {"message": "Invalid JSON format"}
            }, websocket)
            return

        required_keys = {"event", "type", "headers", "data"}
        if not all(k in frame for k in required_keys):
            logger.warning(f"Invalid frame format from user_uid={user_uid}: {frame}")
            await self.send_personal_message({
                "event": "system",
                "type": "error",
                "headers": {},
                "data": {"message": "Frame must contain event, type, headers, and data"}
            }, websocket)
            return

        event = frame["event"]
        type_ = frame["type"]
        headers = frame["headers"] or {}
        data = frame["data"]

        # Heartbeat check
        if event == "system" and type_ == "heartbeat":
            with self._lock:
                if user_uid in self.active_connections:
                    for conn in self.active_connections[user_uid]:
                        if conn["websocket"] == websocket:
                            conn["last_heartbeat"] = time.time()
                            break
            await self.send_personal_message({
                "event": "system",
                "type": "heartbeatAck",
                "headers": {},
                "data": {}
            }, websocket)
            return

        # Client event acknowledgment
        elif event == "system" and type_ == "ack":
            acked_event = data.get("ackedEvent")
            acked_type = data.get("ackedType")
            logger.info(f"WebSocket: Received client ack for event={acked_event}, type={acked_type} from user_uid={user_uid}")

            if acked_event == "chat" and acked_type == "received":
                message_uids = data.get("messageUids", [])
                if message_uids:
                    db = SessionLocal()
                    try:
                        now_dt = now_utc()
                        messages = db.query(models.JobChatMessage).filter(
                            models.JobChatMessage.uid.in_(message_uids),
                            models.JobChatMessage.delivered_at.is_(None)
                        ).all()
                        for msg in messages:
                            msg.delivered_at = now_dt
                            msg.status = "delivered"
                        db.commit()
                        logger.info(f"WebSocket: Marked {len(messages)} messages as delivered based on client ack.")
                        
                        # Broadcast delivery status to the sender
                        if messages:
                            broadcast_data = {
                                "jobId": messages[0].job_id,
                                "messageUids": message_uids,
                                "deliveredAt": to_utc_iso(now_dt)
                            }
                            await self.broadcast_to_job(db, messages[0].job_id, "chat", "delivered", broadcast_data)
                    except Exception as e:
                        logger.error(f"Error marking messages as delivered from ack: {e}", exc_info=True)
                    finally:
                        db.close()
            return

        # Chat send
        elif event == "chat" and type_ == "send":
            auth_header = headers.get("Authorization") or headers.get("authorization")
            if not auth_header or not auth_header.startswith("Bearer "):
                await self.send_personal_message({
                    "event": "chat",
                    "type": "error",
                    "headers": {},
                    "data": {"message": "Missing or invalid Authorization header"}
                }, websocket)
                return

            token = auth_header.split(" ")[1]
            try:
                payload = token_service.decode_token(token, expected_type="access")
                token_user_uid = payload.get("sub")
                if token_user_uid != user_uid:
                    await self.send_personal_message({
                        "event": "chat",
                        "type": "error",
                        "headers": {},
                        "data": {"message": "Token does not match the connected user"}
                    }, websocket)
                    return
            except Exception as e:
                await self.send_personal_message({
                    "event": "chat",
                    "type": "error",
                    "headers": {},
                    "data": {"message": f"Token validation failed: {str(e)}"}
                }, websocket)
                return

            db = SessionLocal()
            try:
                current_user = db.query(models.User).filter(models.User.uid == user_uid).first()
                if not current_user:
                    await self.send_personal_message({
                        "event": "chat",
                        "type": "error",
                        "headers": {},
                        "data": {"message": "User not found"}
                    }, websocket)
                    return

                if isinstance(data, dict):
                    msg_list = data.get("messages", [])
                else:
                    msg_list = data
                messages_data = [schemas.JobChatMessageCreate.model_validate(msg) for msg in msg_list]
                if not messages_data:
                    return

                job_id = messages_data[0].job_id
                response_data = job_chat_service.send_job_messages(db, job_id, messages_data, current_user)
                db.commit()

                broadcast_data = {
                    "message": response_data["messages"][-1] if response_data["messages"] else None,
                    "messages": response_data["messages"],
                    "job": response_data["job"]
                }
                await self.broadcast_to_job(db, job_id, "chat", "received", broadcast_data)

                # Broadcast seen status for previous messages if any were marked as seen
                seen_message_uids = response_data.get("seenMessageUids", [])
                if seen_message_uids:
                    seen_broadcast_data = {
                        "jobId": job_id,
                        "messageUids": seen_message_uids,
                        "seenAt": to_utc_iso()
                    }
                    await self.broadcast_to_job(db, job_id, "chat", "seen", seen_broadcast_data)
                    
                    try:
                        from services.notification_service import send_cancel_notification_push
                        send_cancel_notification_push(db, user_uid, job_id)
                    except Exception as e:
                        logger.error(f"Error sending cancelNotification FCM from send: {e}", exc_info=True)

            except Exception as e:
                logger.error(f"Error handling chat send for user_uid={user_uid}: {e}", exc_info=True)
                detail = getattr(e, "detail", str(e))
                await self.send_personal_message({
                    "event": "chat",
                    "type": "error",
                    "headers": {},
                    "data": {"message": detail}
                }, websocket)
            finally:
                db.close()

        # Chat delete
        elif event == "chat" and type_ == "delete":
            auth_header = headers.get("Authorization") or headers.get("authorization")
            if not auth_header or not auth_header.startswith("Bearer "):
                await self.send_personal_message({
                    "event": "chat",
                    "type": "error",
                    "headers": {},
                    "data": {"message": "Missing or invalid Authorization header"}
                }, websocket)
                return

            token = auth_header.split(" ")[1]
            try:
                payload = token_service.decode_token(token, expected_type="access")
                token_user_uid = payload.get("sub")
                if token_user_uid != user_uid:
                    await self.send_personal_message({
                        "event": "chat",
                        "type": "error",
                        "headers": {},
                        "data": {"message": "Token does not match the connected user"}
                    }, websocket)
                    return
            except Exception as e:
                await self.send_personal_message({
                    "event": "chat",
                    "type": "error",
                    "headers": {},
                    "data": {"message": f"Token validation failed: {str(e)}"}
                }, websocket)
                return

            db = SessionLocal()
            try:
                current_user = db.query(models.User).filter(models.User.uid == user_uid).first()
                if not current_user:
                    await self.send_personal_message({
                        "event": "chat",
                        "type": "error",
                        "headers": {},
                        "data": {"message": "User not found"}
                    }, websocket)
                    return

                delete_req = schemas.JobChatMessageDeleteRequest.model_validate(data)
                job_id = data.get("jobId")
                if not job_id:
                    await self.send_personal_message({
                        "event": "chat",
                        "type": "error",
                        "headers": {},
                        "data": {"message": "jobId is required"}
                    }, websocket)
                    return

                job_chat_service.delete_job_messages(db, job_id, delete_req, current_user)

                broadcast_data = {
                    "jobId": job_id,
                    "messageUids": delete_req.message_uids
                }
                await self.broadcast_to_job(db, job_id, "chat", "deleted", broadcast_data)

            except Exception as e:
                logger.error(f"Error handling chat delete for user_uid={user_uid}: {e}", exc_info=True)
                detail = getattr(e, "detail", str(e))
                await self.send_personal_message({
                    "event": "chat",
                    "type": "error",
                    "headers": {},
                    "data": {"message": detail}
                }, websocket)
            finally:
                db.close()

        # Chat seen
        elif event == "chat" and type_ == "seen":
            auth_header = headers.get("Authorization") or headers.get("authorization")
            if not auth_header or not auth_header.startswith("Bearer "):
                await self.send_personal_message({
                    "event": "chat",
                    "type": "error",
                    "headers": {},
                    "data": {"message": "Missing or invalid Authorization header"}
                }, websocket)
                return

            token = auth_header.split(" ")[1]
            try:
                payload = token_service.decode_token(token, expected_type="access")
                token_user_uid = payload.get("sub")
                if token_user_uid != user_uid:
                    await self.send_personal_message({
                        "event": "chat",
                        "type": "error",
                        "headers": {},
                        "data": {"message": "Token does not match the connected user"}
                    }, websocket)
                    return
            except Exception as e:
                await self.send_personal_message({
                    "event": "chat",
                    "type": "error",
                    "headers": {},
                    "data": {"message": f"Token validation failed: {str(e)}"}
                }, websocket)
                return

            db = SessionLocal()
            try:
                member = db.query(models.Member).filter(models.Member.user_uid == user_uid).first()
                if not member:
                    await self.send_personal_message({
                        "event": "chat",
                        "type": "error",
                        "headers": {},
                        "data": {"message": "Member profile not found"}
                    }, websocket)
                    return

                job_id = data.get("jobId")
                if not job_id:
                    await self.send_personal_message({
                        "event": "chat",
                        "type": "error",
                        "headers": {},
                        "data": {"message": "jobId is required"}
                    }, websocket)
                    return

                req_message_uids = data.get("messageUids")
                now_dt = now_utc()
                query = db.query(models.JobChatMessage).filter(
                    models.JobChatMessage.job_id == job_id,
                    models.JobChatMessage.sender_uid != member.uid,
                    models.JobChatMessage.seen_at.is_(None)
                )
                if req_message_uids:
                    query = query.filter(models.JobChatMessage.uid.in_(req_message_uids))
                messages = query.all()

                message_uids = [m.uid for m in messages]
                for msg in messages:
                    msg.seen_at = now_dt
                db.commit()

                if message_uids:
                    broadcast_data = {
                        "jobId": job_id,
                        "messageUids": message_uids,
                        "seenAt": to_utc_iso(now_dt)
                    }
                    await self.broadcast_to_job(db, job_id, "chat", "seen", broadcast_data)
                    
                    # Send cancel notification silent FCM to current user's other devices
                    try:
                        from services.notification_service import send_cancel_notification_push
                        send_cancel_notification_push(db, user_uid, job_id)
                    except Exception as e:
                        logger.error(f"Error sending cancelNotification FCM from WebSocket: {e}", exc_info=True)

            except Exception as e:
                logger.error(f"Error handling chat seen for user_uid={user_uid}: {e}", exc_info=True)
            finally:
                db.close()

        else:
            logger.warning(f"Unsupported event category/type: {event}/{type_}")
            await self.send_personal_message({
                "event": "system",
                "type": "error",
                "headers": {},
                "data": {"message": f"Unsupported event category or type: {event}/{type_}"}
            }, websocket)

websocket_manager = WebSocketConnectionManager()
