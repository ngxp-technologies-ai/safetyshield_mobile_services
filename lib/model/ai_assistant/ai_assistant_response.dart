class AiAssistantResponse {
  final String answer;
  final String sessionId;
  final List<Source> sources;
  final int documentsRetrieved;

  AiAssistantResponse({
    required this.answer,
    required this.sessionId,
    required this.sources,
    required this.documentsRetrieved,
  });

  factory AiAssistantResponse.fromJson(Map<String, dynamic> json) {
    return AiAssistantResponse(
      answer: json['answer'] ?? '',
      sessionId: json['session_id'] ?? '',
      sources: (json['sources'] as List? ?? [])
          .map((i) => Source.fromJson(i))
          .toList(),
      documentsRetrieved: json['documents_retrieved'] ?? 0,
    );
  }
}

class Source {
  final String sourceType;
  final int sourceId;
  final double similarity;

  Source({
    required this.sourceType,
    required this.sourceId,
    required this.similarity,
  });

  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      sourceType: json['source_type'] ?? '',
      sourceId: json['source_id'] ?? 0,
      similarity: (json['similarity'] ?? 0).toDouble(),
    );
  }
}
