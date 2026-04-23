import 'package:flutter/material.dart';
import 'package:safety_management/model/alert/alert_model.dart';
import 'package:safety_management/repository/alert/alert_repository.dart';
import 'package:safety_management/utils/notify_snackbar.dart';

class AlertController extends ChangeNotifier {
  final AlertRepository _repository = AlertRepository();

  bool isLoading = false;
  List<AlertModel> activeAlerts = [];
  List<AlertModel> acknowledgedAlerts = [];
  // Fetch the list of active alerts and update the state
  Future<void> fetchActiveAlerts({bool showLoader = true}) async {
    try {
      if (showLoader) {
        isLoading = true;
        notifyListeners();
      }

      final response = await _repository.getActiveAlerts();
      activeAlerts = response;
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

  // Fetch the list of acknowledged alerts and update the state
  Future<void> fetchAcknowledgedAlerts({bool showLoader = true}) async {
    try {
      if (showLoader) {
        isLoading = true;
        notifyListeners();
      }

      final response = await _repository.getAcknowledgedAlerts();
      acknowledgedAlerts = response;
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

  // Acknowledge an alert by its ID and refresh the active alerts list
  Future<void> acknowledgeAlert(int id) async {
    try {
      await _repository.acknowledgeAlert(id);
      // Refresh active alerts after acknowledgement
      await fetchActiveAlerts(showLoader: false);
    } catch (e) {
      NotifySnackBar.show(
        e.toString().replaceFirst("Exception: ", ""),
        SnackBarType.fail,
      );
    }
  }
}
