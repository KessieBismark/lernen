class ChatMessage {
  final String deviceID;
  final Sessions sessions;

  ChatMessage({
    required this.deviceID,
    required this.sessions,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(deviceID: json['device_id'], sessions: json['sessions']);
  }
}

class Sessions {
  final String deviceID;
  final String sessionID;
  final String title;
  final dynamic memory;

  Sessions(
      {required this.deviceID,
      required this.title,
      required this.sessionID,
      required this.memory});
}
