enum WebSocketEvents {
  connection('connection'),
  heartbeat('heartbeat'),
  token('token'),
  message('message'),
  error('error');

  final String value;
  const WebSocketEvents(this.value);

  // Getter to sub-category types
  dynamic get types {
    switch (this) {
      case WebSocketEvents.connection:
        return const WebSocketConnectionTypes();
      case WebSocketEvents.heartbeat:
        return const WebSocketHeartbeatTypes();
      case WebSocketEvents.token:
        return const WebSocketTokenTypes();
      case WebSocketEvents.message:
        return const WebSocketMessageTypes();
      case WebSocketEvents.error:
        return const WebSocketErrorTypes();
    }
  }
}

enum WebSocketConnectionType {
  connected('connected');

  final String value;
  const WebSocketConnectionType(this.value);
}

class WebSocketConnectionTypes {
  const WebSocketConnectionTypes();
  WebSocketConnectionType get connected => WebSocketConnectionType.connected;
}

enum WebSocketHeartbeatType {
  ping('ping'),
  pong('pong');

  final String value;
  const WebSocketHeartbeatType(this.value);
}

class WebSocketHeartbeatTypes {
  const WebSocketHeartbeatTypes();
  WebSocketHeartbeatType get ping => WebSocketHeartbeatType.ping;
  WebSocketHeartbeatType get pong => WebSocketHeartbeatType.pong;
}

enum WebSocketTokenType {
  renewal('renewal');

  final String value;
  const WebSocketTokenType(this.value);
}

class WebSocketTokenTypes {
  const WebSocketTokenTypes();
  WebSocketTokenType get renewal => WebSocketTokenType.renewal;
}

enum WebSocketMessageType {
  ack('ack'),
  sendMessage('send'),
  sendResponse('send_response'),
  newMessage('new_message'),
  deleteMessage('delete'),
  deleteResponse('delete_response'),
  deleted('deleted'),
  readMessage('seen'),
  seenResponse('seen_response'),
  ackReceived('ack_received');

  final String value;
  const WebSocketMessageType(this.value);
}

class WebSocketMessageTypes {
  const WebSocketMessageTypes();

  WebSocketMessageType get ack => WebSocketMessageType.ack;
  WebSocketMessageType get sendMessage => WebSocketMessageType.sendMessage;
  WebSocketMessageType get sendResponse => WebSocketMessageType.sendResponse;
  WebSocketMessageType get newMessage => WebSocketMessageType.newMessage;
  WebSocketMessageType get deleteMessage => WebSocketMessageType.deleteMessage;
  WebSocketMessageType get deleteResponse => WebSocketMessageType.deleteResponse;
  WebSocketMessageType get deleted => WebSocketMessageType.deleted;
  WebSocketMessageType get readMessage => WebSocketMessageType.readMessage;
  WebSocketMessageType get seen => WebSocketMessageType.readMessage; // Alias for seen
  WebSocketMessageType get seenResponse => WebSocketMessageType.seenResponse;
  WebSocketMessageType get ackReceived => WebSocketMessageType.ackReceived;
}

enum WebSocketErrorType {
  error('error');

  final String value;
  const WebSocketErrorType(this.value);
}

class WebSocketErrorTypes {
  const WebSocketErrorTypes();
  WebSocketErrorType get error => WebSocketErrorType.error;
}
