import 'package:flutter/material.dart';

import '../../model/ai_assistant/ai_assistant_model.dart';
import '../../model/ai_assistant/ai_assistant_request.dart';
import '../../repository/ai_assistant/ai_assistant_repository.dart';

class AiAssistantController extends ChangeNotifier {
  final AiAssistantRepository _repository = AiAssistantRepository();
  final List<AiMessage> _messages = [];
  bool _isLoading = false;
  String _sessionId = "string"; // Initial session ID, can be updated from response

  List<AiMessage> get messages => _messages;
  bool get isLoading => _isLoading;

  Future<void> sendMessage(String userText) async {
    if (userText.trim().isEmpty) return;

    // Add user message
    _messages.add(
      AiMessage(
        content: userText,
        role: MessageRole.user,
        timestamp: DateTime.now(),
      ),
    );
    _isLoading = true;
    notifyListeners();

    try {
      final request = AiAssistantRequest(
        message: userText,
        sessionId: _sessionId,
      );

      final response = await _repository.askQuestion(request);

      if (response != null) {
        _sessionId = response.sessionId;
        _messages.add(
          AiMessage(
            content: response.answer,
            role: MessageRole.assistant,
            timestamp: DateTime.now(),
          ),
        );
      } else {
        throw Exception("Failed to get response from AI");
      }
    } catch (e) {
      _messages.add(
        AiMessage(
          content: 'Sorry, I encountered an error. Please try again.',
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
        ),
      );
    }

    _isLoading = false;
    notifyListeners();
  }

  void clearChat() {
    _messages.clear();
    _sessionId = "string"; // Reset session ID on clear
    notifyListeners();
  }
}
