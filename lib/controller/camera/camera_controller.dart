import 'package:flutter/material.dart';
import '../../model/camera/camera_model.dart';
import '../../repository/camera/camera_repository.dart';

class CameraController extends ChangeNotifier {
  final CameraRepository _repository = CameraRepository();
  List<CameraModel> _cameras = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CameraModel> get cameras => _cameras;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  List<CameraModel> get activeCameras =>
      _cameras.where((c) => c.isActive).toList();

  List<CameraModel> get alertCameras =>
      _cameras.where((c) => c.alertCount > 0).toList();

  Future<void> fetchCameras() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _cameras = await _repository.getCameras();
    } catch (e) {
      _errorMessage = "Failed to load cameras. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
