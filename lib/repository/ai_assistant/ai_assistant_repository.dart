import '../../network/api_endpoints.dart';
import '../../network/api_providers.dart';
import '../../model/ai_assistant/ai_assistant_request.dart';
import '../../model/ai_assistant/ai_assistant_response.dart';

class AiAssistantRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<AiAssistantResponse?> askQuestion(AiAssistantRequest request) async {
    try {
      final response = await _apiProvider.post(
        ApiEndpoint.chatAsk,
        body: request.toJson(),
        requiresAuth: true,
      );

      if (response != null) {
        return AiAssistantResponse.fromJson(response);
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }
}
