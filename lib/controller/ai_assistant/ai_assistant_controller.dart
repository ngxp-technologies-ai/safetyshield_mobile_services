import 'package:flutter/material.dart';

import '../../model/ai_assistant/ai_assistant_model.dart';

class AiAssistantController extends ChangeNotifier {
  final List<AiMessage> _messages = [];
  bool _isLoading = false;

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
      // For now, using a Mock Response because the API Key is missing.
      // In a real app, this would call your backend or a direct AI service.
      await Future.delayed(const Duration(seconds: 2));

      String aiReply = _getMockResponse(userText);

      _messages.add(
        AiMessage(
          content: aiReply,
          role: MessageRole.assistant,
          timestamp: DateTime.now(),
        ),
      );
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

  String _getMockResponse(String query) {
    final lowerQuery = query.toLowerCase();

    if (lowerQuery.contains('hi') || lowerQuery.contains('hello')) {
      return "Hello! I'm your SafetyShield AI Assistant. How can I help you today with site safety at Metro Line 3?";
    } else if (lowerQuery.contains('ppe') || lowerQuery.contains('helmet')) {
      return "I've noticed a slight increase in PPE non-compliance in Zone B. Would you like me to generate a report for the upcoming toolbox talk?";
    } else if (lowerQuery.contains('alert') || lowerQuery.contains('active')) {
      return "Currently, there are 80 active alerts. Most of them are concentrated in the Foundation pit. I recommend checking the Scaffolding Zone for helmet compliance.";
    } else if (lowerQuery.contains('crew') || lowerQuery.contains('worker')) {
      return "Total crew on shift is 29. Fatigue levels appear stable, but I'll continue monitoring the 'no vest' violations reported earlier.";
    } else {
      return "That's an interesting point. As your safety assistant, I'm monitoring real-time data from cameras and sensors across Metro Line 3 to help prevent incidents. Could you provide more details?";
    }
  }

  void clearChat() {
    _messages.clear();
    notifyListeners();
  }
}
