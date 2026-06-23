from fastapi import APIRouter, WebSocket, WebSocketDisconnect
import random
import asyncio
import logging
from services.websocket_service import websocket_manager
from services.token_service import token_service
from core.config import WS_HEARTBEAT_GRACE_SECONDS

logger = logging.getLogger("websocket_router")

router = APIRouter(tags=["WebSocket"])

@router.websocket("/ws")
async def websocket_endpoint(
    websocket: WebSocket
):
    # 1. Retrieve the access token from the query parameter or the Authorization header
    token = websocket.query_params.get("token")
    if not token:
        auth_header = websocket.headers.get("authorization") or websocket.headers.get("Authorization")
        if auth_header and auth_header.startswith("Bearer "):
            token = auth_header.split(" ")[1]

    # 2. Extract device headers if present
    device_id = (
        websocket.headers.get("x-device-id") or 
        websocket.headers.get("device-id") or 
        websocket.query_params.get("device_id") or 
        websocket.query_params.get("x-device-id") or 
        "unknown-device"
    )

    if not token:
        logger.warning("WebSocket handshake rejected: token missing.")
        # Reject handshake with custom code
        await websocket.close(code=4001)
        return

    # 3. Decode the token using token_service
    try:
        payload = token_service.decode_token(token, expected_type="access")
        user_uid = payload.get("sub")
        phone = payload.get("phone", "")
        exp_time = payload.get("exp")
        if not user_uid:
            raise Exception("Sub claim missing from token.")
    except Exception as e:
        logger.warning(f"WebSocket handshake rejected: invalid token. Details: {e}")
        await websocket.close(code=4001)
        return

    # 4. Accept connection
    await websocket.accept()

    # 5. Generate random heartbeat interval between 30 and 60 seconds
    heartbeat_interval = random.randint(30, 60)

    # 6. Send the initial connected event
    connected_frame = {
        "event": "connection",
        "type": "connected",
        "headers": {},
        "data": {
            "heartbeatIntervalSeconds": heartbeat_interval
        }
    }
    
    try:
        await websocket.send_json(connected_frame)
    except Exception as e:
        logger.error(f"Failed to send connected frame to user {user_uid}: {e}")
        await websocket.close()
        return

    # 7. Register the connection in WebSocketConnectionManager
    websocket_manager.connect(websocket, user_uid, phone, device_id, exp_time)

    # 8. Frame receive loop with heartbeat timeout monitoring
    try:
        while True:
            try:
                # Wait for a message. Timeout if no message (or heartbeat) is received
                # within heartbeatIntervalSeconds + WS_HEARTBEAT_GRACE_SECONDS seconds.
                data_text = await asyncio.wait_for(
                    websocket.receive_text(),
                    timeout=heartbeat_interval + WS_HEARTBEAT_GRACE_SECONDS
                )
            except asyncio.TimeoutError:
                logger.warning(f"WebSocket connection timed out for user {user_uid} due to lack of heartbeat.")
                break

            await websocket_manager.handle_message(websocket, user_uid, data_text)

    except WebSocketDisconnect:
        logger.info(f"WebSocket disconnected naturally for user {user_uid}")
    except Exception as e:
        logger.error(f"Exception in WebSocket loop for user {user_uid}: {e}", exc_info=True)
    finally:
        # 9. Clean up and unregister connection
        websocket_manager.disconnect(user_uid, websocket)
        try:
            await websocket.close()
        except Exception:
            pass
