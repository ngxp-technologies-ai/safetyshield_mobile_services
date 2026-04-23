import 'dart:developer';
import 'package:flutter/material.dart';
import '../../model/equipment/equipment_model.dart';
import '../../repository/equipment/equipment_repository.dart';

class EquipmentController with ChangeNotifier {
  final EquipmentRepository _repository = EquipmentRepository();

  List<EquipmentModel> _allEquipments = [];
  bool _isLoading = false;
  String _errorMessage = '';

  int _selectedTabIndex = 0;
  String _searchQuery = '';
  final Set<String> _selectedTypes = {};

  List<EquipmentModel> get allEquipments => _allEquipments;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;
  int get selectedTabIndex => _selectedTabIndex;
  String get searchQuery => _searchQuery;
  Set<String> get selectedTypes => _selectedTypes;

  final List<String> tabs = ['All', 'Active', 'Idle', 'Maintenance', 'Alerts'];

  Future<void> fetchEquipment({int? zoneId}) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    try {
      _allEquipments = await _repository.getEquipment(zoneId: zoneId);
      log("Fetched ${_allEquipments.length} equipment items");
    } catch (e) {
      log("EquipmentController Error: $e");
      _errorMessage = "Failed to load equipment. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<EquipmentModel> get filteredEquipments {
    List<EquipmentModel> list = _allEquipments;

    // Filter by tab
    if (_selectedTabIndex > 0) {
      final tab = tabs[_selectedTabIndex];
      // Note: 'Alerts' tab logic might need careful handling if it's not a direct status
      if (tab == 'Alerts') {
         // Assuming alerts means equipment with alerts, for now just filtering by some logic if applicable
         // list = list.where((e) => e.hasAlerts).toList(); 
      } else {
        list = list.where((e) => e.statusLabel == tab).toList();
      }
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      list = list.where((e) =>
          e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.equipmentCode.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
    }

    // Filter by type
    if (_selectedTypes.isNotEmpty) {
      list = list.where((e) => _selectedTypes.contains(e.equipmentType)).toList();
    }

    return list;
  }

  void setTabIndex(int index) {
    _selectedTabIndex = index;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  void toggleType(String type) {
    if (_selectedTypes.contains(type)) {
      _selectedTypes.remove(type);
    } else {
      _selectedTypes.add(type);
    }
    notifyListeners();
  }

  void clearFilters() {
    _selectedTypes.clear();
    notifyListeners();
  }

  List<String> get availableTypes {
    return _allEquipments.map((e) => e.equipmentType).toSet().toList();
  }

  int getCountForTab(String tab) {
    if (tab == 'All') return _allEquipments.length;
    if (tab == 'Alerts') return 0; // Placeholder until alert logic is defined
    return _allEquipments.where((e) => e.statusLabel == tab).length;
  }
}
