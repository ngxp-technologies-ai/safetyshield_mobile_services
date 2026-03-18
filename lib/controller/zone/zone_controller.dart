import 'dart:developer';
import 'package:flutter/material.dart';
import '../../model/zone/zone_model.dart';
import '../../repository/zone/zone_repository.dart';

class ZoneController with ChangeNotifier {
  final ZoneRepository _zoneRepository = ZoneRepository();

  List<ZoneModel> _zones = [];
  bool _isLoading = false;
  String _errorMessage = '';

  List<ZoneModel> get zones => _zones;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchZones() async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _zones = await _zoneRepository.getZones();
    } catch (e) {
      log("ZoneController Error: $e");
      _errorMessage = "Failed to load zone rules. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
