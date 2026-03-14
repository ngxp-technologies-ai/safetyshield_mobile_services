// model/ai/ai_message_model.dart

enum MessageRole { user, assistant }

class AiMessage {
  final String content;
  final MessageRole role;
  final DateTime timestamp;

  AiMessage({
    required this.content,
    required this.role,
    required this.timestamp,
  });
}
