import 'package:flutter/material.dart';
import 'package:safety_management/model/dashboard/dashboard_stats_model.dart';
import 'package:safety_management/repository/dashboard/dashboard_repository.dart';

class DashboardController extends ChangeNotifier {
  final DashboardRepository _repository = DashboardRepository();

  DashboardStatsModel _stats = DashboardStatsModel.empty();
  DashboardStatsModel get stats => _stats;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _error;
  String? get error => _error;

  Future<void> fetchDashboardStats() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _stats = await _repository.getDashboardStats();
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
