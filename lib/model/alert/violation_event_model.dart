class ViolationEventModel {
  final String eventId;
  final String violationType;
  final double confidence;
  final List<double> bbox;
  final String personId;
  final String cameraId;
  final String snapshotUrl;
  final String? annotatedImageUrl;
  final String severity;
  final String timestamp;
  final String? detectedClasses;
  final String? notDetectedClasses;

  const ViolationEventModel({
    required this.eventId,
    required this.violationType,
    required this.confidence,
    required this.bbox,
    required this.personId,
    required this.cameraId,
    required this.snapshotUrl,
    this.annotatedImageUrl,
    required this.severity,
    required this.timestamp,
    this.detectedClasses,
    this.notDetectedClasses,
  });

  factory ViolationEventModel.fromJson(Map<String, dynamic> json) {
    return ViolationEventModel(
      eventId: json['event_id'] ?? '',
      violationType: json['violation_type'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      bbox: (json['bbox'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      personId: json['person_id'] ?? '',
      cameraId: json['camera_id'] ?? '',
      snapshotUrl: json['snapshot_url'] ?? '',
      annotatedImageUrl: json['annotated_image_url'],
      severity: json['severity'] ?? '',
      timestamp: json['timestamp'] ?? '',
      detectedClasses: json['detected_classes'],
      notDetectedClasses: json['not_detected_classes'],
    );
  }

  /// Content fingerprint for deduplication (camera_id + violation_type + timestamp rounded to 5s)
  String get fingerprint {
    final ts = DateTime.tryParse('${timestamp}Z');
    if (ts == null) return '${cameraId}_${violationType}_$timestamp';
    final rounded = ts.millisecondsSinceEpoch ~/ 5000;
    return '${cameraId}_${violationType}_$rounded';
  }

  String get violationTitle {
    switch (violationType) {
      case 'no_helmet':
        return 'No Helmet Detected';
      case 'no_mask':
        return 'No Mask Detected';
      case 'no_vest':
        return 'No Safety Vest Detected';
      case 'no_harness':
        return 'No Harness Detected';
      case 'no_gloves':
        return 'No Gloves Detected';
      case 'no_goggles':
        return 'No Goggles Detected';
      case 'no_boots':
        return 'No Boots Detected';
      case 'no_safety_glasses':
        return 'No Safety Glasses Detected';
      case 'person_down':
        return 'Person Down';
      case 'zone_violation':
        return 'Zone Violation';
      default:
        return violationType
            .replaceAll('_', ' ')
            .split(' ')
            .map((e) => e.isEmpty ? e : e[0].toUpperCase() + e.substring(1))
            .join(' ');
    }
  }
}
