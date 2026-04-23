import 'package:flutter/material.dart';
import 'package:safety_management/model/alert/alert_stats_model.dart';
import 'package:safety_management/repository/alert/alert_repository.dart';
import 'package:safety_management/utils/notify_snackbar.dart';

class AlertStatsController extends ChangeNotifier {
  final AlertRepository _repository = AlertRepository();

  bool isLoading = false;
  AlertStatsModel stats = AlertStatsModel.empty();
  //
  Future<void> fetchAlertStats({bool showLoader = true}) async {
    try {
      if (showLoader) {
        isLoading = true;
        notifyListeners();
      }

      final response = await _repository.getAlertStats();
      stats = response;
    } catch (e) {
      NotifySnackBar.show(
        e.toString().replaceFirst("Exception: ", ""),
        SnackBarType.fail,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
