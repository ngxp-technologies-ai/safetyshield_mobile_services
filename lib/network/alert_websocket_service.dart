import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:web_socket_channel/web_socket_channel.dart';
import '../model/alert/violation_event_model.dart';

/// Callback invoked when a new, deduplicated violation event arrives.
typedef OnViolationEvent = void Function(ViolationEventModel event);

class AlertWebSocketService {
  static const String _wsUrl = 'wss://safety-qa-api.prod-app.in/ws/violations';
  static const int _maxRetryDelay = 30;
  static const int _maxJitterMs = 500;

  WebSocketChannel? _channel;
  StreamSubscription? _subscription;
  Timer? _reconnectTimer;

  bool _disposed = false;
  int _retrySeconds = 1;

  final Set<String> _seenEventIds = {};
  final Set<String> _seenFingerprints = {};

  OnViolationEvent? onEvent;

  void connect() {
    _disposed = false;
    _tryConnect();
  }

  void _tryConnect() {
    if (_disposed) return;

    try {
      _channel = WebSocketChannel.connect(Uri.parse(_wsUrl));
      _subscription = _channel!.stream.listen(
        _onData,
        onError: _onError,
        onDone: _onDone,
        cancelOnError: false,
      );
      // Reset backoff on successful connect
      _retrySeconds = 1;
    } catch (_) {
      _scheduleReconnect();
    }
  }

  void _onData(dynamic raw) {
    try {
      final Map<String, dynamic> json = jsonDecode(raw as String);

      // Skip report_status events
      if (json['event'] == 'report_status') return;
      // Skip done events
      if (json['event'] == 'done') return;

      final event = ViolationEventModel.fromJson(json);

      // Deduplication: event_id
      if (event.eventId.isNotEmpty && _seenEventIds.contains(event.eventId)) {
        return;
      }
      // Deduplication: content fingerprint
      if (_seenFingerprints.contains(event.fingerprint)) return;

      if (event.eventId.isNotEmpty) _seenEventIds.add(event.eventId);
      _seenFingerprints.add(event.fingerprint);

      onEvent?.call(event);
    } catch (_) {
      // Malformed message — ignore
    }
  }

  void _onError(Object error) {
    _cleanup();
    _scheduleReconnect();
  }

  void _onDone() {
    _cleanup();
    if (!_disposed) _scheduleReconnect();
  }

  void _scheduleReconnect() {
    if (_disposed) return;
    final jitter = Random().nextInt(_maxJitterMs);
    final delay = Duration(seconds: _retrySeconds, milliseconds: jitter);
    _reconnectTimer = Timer(delay, _tryConnect);
    // Exponential backoff: double until max
    _retrySeconds = min(_retrySeconds * 2, _maxRetryDelay);
  }

  void _cleanup() {
    _subscription?.cancel();
    _subscription = null;
    _channel = null;
  }

  void disconnect() {
    _disposed = true;
    _reconnectTimer?.cancel();
    _reconnectTimer = null;
    _cleanup();
    _channel?.sink.close();
  }
}
