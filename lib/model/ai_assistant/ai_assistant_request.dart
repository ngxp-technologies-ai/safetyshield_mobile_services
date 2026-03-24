class AiAssistantRequest {
  final String message;
  final String sessionId;

  AiAssistantRequest({
    required this.message,
    required this.sessionId,
  });

  Map<String, dynamic> toJson() {
    return {
      'message': message,
      'session_id': sessionId,
    };
  }
}
