import 'package:flutter/material.dart';
import '../../model/alert/violation_event_model.dart';
import '../../network/alert_websocket_service.dart';

class AlertWebSocketController extends ChangeNotifier {
  static const int _maxEvents = 50;

  final AlertWebSocketService _service = AlertWebSocketService();

  final List<ViolationEventModel> violations = [];
  int _unreadCount = 0;

  int get unreadCount => _unreadCount;

  void connect() {
    _service.onEvent = _onNewEvent;
    _service.connect();
  }

  void _onNewEvent(ViolationEventModel event) {
    violations.insert(0, event);
    if (violations.length > _maxEvents) violations.removeLast();
    _unreadCount++;
    notifyListeners();
  }

  /// Call this when the user opens the alert panel to reset the badge count.
  void clearUnread() {
    _unreadCount = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    _service.disconnect();
    super.dispose();
  }
}
