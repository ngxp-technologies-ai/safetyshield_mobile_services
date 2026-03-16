import 'package:flutter/material.dart';
import '../../model/equipment/equipment_model.dart';

class EquipmentController with ChangeNotifier {
  final List<EquipmentModel> _allEquipments = [
    const EquipmentModel(
      id: 'TC-200',
      name: 'Tower Crane',
      location: 'Grid A3',
      status: EquipmentStatus.active,
      utilization: 0.78,
      operatorName: 'Ahmed Hassan',
      runtimeToday: '6.5h today',
      alertCount: 2,
      alertMessage: '2 proximity alerts today',
    ),
    const EquipmentModel(
      id: 'CAT 320',
      name: 'Excavator',
      location: 'Grid C4',
      status: EquipmentStatus.active,
      utilization: 0.85,
      operatorName: 'Ravi Patel',
      runtimeToday: '7.1h today',
    ),
    const EquipmentModel(
      id: 'CM-50',
      name: 'Concrete Mixer',
      location: 'Staging Area',
      status: EquipmentStatus.idle,
      utilization: 0.30,
      operatorName: 'Unassigned',
      runtimeToday: '2.1h today',
    ),
    const EquipmentModel(
      id: 'WS-12',
      name: 'Welding Set',
      location: 'Grid B2',
      status: EquipmentStatus.active,
      utilization: 0.60,
      operatorName: 'John Doe',
      runtimeToday: '4.2h today',
    ),
    const EquipmentModel(
      id: 'LT-10',
      name: 'Light Tower',
      location: 'Zone B',
      status: EquipmentStatus.maintenance,
      utilization: 0.0,
      operatorName: 'Service Dept',
      runtimeToday: '0h today',
    ),
  ];

  int _selectedTabIndex = 0;
  String _searchQuery = '';

  int get selectedTabIndex => _selectedTabIndex;
  String get searchQuery => _searchQuery;

  final List<String> tabs = ['All', 'Active', 'Idle', 'Maintenance', 'Alerts'];

  List<EquipmentModel> get filteredEquipments {
    List<EquipmentModel> list = _allEquipments;

    // Filter by tab
    if (_selectedTabIndex > 0) {
      final tab = tabs[_selectedTabIndex];
      if (tab == 'Alerts') {
        list = list.where((e) => e.alertCount > 0).toList();
      } else {
        list = list.where((e) => e.statusLabel == tab).toList();
      }
    }

    // Filter by search
    if (_searchQuery.isNotEmpty) {
      list = list.where((e) =>
          e.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          e.id.toLowerCase().contains(_searchQuery.toLowerCase())).toList();
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

  int getCountForTab(String tab) {
    if (tab == 'All') return _allEquipments.length;
    if (tab == 'Alerts') return _allEquipments.where((e) => e.alertCount > 0).length;
    return _allEquipments.where((e) => e.statusLabel == tab).length;
  }
}
