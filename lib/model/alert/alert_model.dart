class AlertModel {
  final int id;
  final String violationType;
  final double confidence;
  final List<double> bbox;
  final String personId;
  final String cameraId;
  final String snapshotUrl;
  final String timestamp;
  final String createdAt;
  final String severity;
  final bool isAcknowledged;
  final String? acknowledgedBy;
  final String? acknowledgedAt;

  const AlertModel({
    required this.id,
    required this.violationType,
    required this.confidence,
    required this.bbox,
    required this.personId,
    required this.cameraId,
    required this.snapshotUrl,
    required this.timestamp,
    required this.createdAt,
    required this.severity,
    required this.isAcknowledged,
    this.acknowledgedBy,
    this.acknowledgedAt,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? 0,
      violationType: json['violation_type'] ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
      bbox: (json['bbox'] as List<dynamic>? ?? [])
          .map((e) => (e as num).toDouble())
          .toList(),
      personId: json['person_id'] ?? '',
      cameraId: json['camera_id'] ?? '',
      snapshotUrl: json['snapshot_url'] ?? '',
      timestamp: json['timestamp'] ?? '',
      createdAt: json['created_at'] ?? '',
      severity: json['severity'] ?? 'warning',
      isAcknowledged: json['is_acknowledged'] ?? false,
      acknowledgedBy: json['acknowledged_by'],
      acknowledgedAt: json['acknowledged_at'],
    );
  }

  String get violationTitle {
    switch (violationType) {
      case 'no_helmet':
        return 'No Helmet Detected';
      case 'no_mask':
        return 'No Mask Detected';
      case 'no_vest':
        return 'No Safety Vest Detected';
      default:
        return violationType
            .replaceAll('_', ' ')
            .split(' ')
            .map((e) => e[0].toUpperCase() + e.substring(1))
            .join(' ');
    }
  }
}
