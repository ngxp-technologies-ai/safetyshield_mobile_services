import 'dart:async';
import 'package:flutter/material.dart';
import 'package:safety_management/model/crew/my_crew_response_model.dart';
import 'package:safety_management/repository/crew/my_crew_repository.dart';
import 'package:safety_management/utils/notify_snackbar.dart';

class MyCrewController extends ChangeNotifier {
  final MyCrewRepository _repository = MyCrewRepository();

  final TextEditingController searchController = TextEditingController();

  bool isLoading = false;
  bool isSearching = false;

  List<CrewWorkerModel> workers = [];
  int total = 0;

  Timer? _debounce;

  Future<void> fetchMyCrew({String? search, bool showLoader = true}) async {
    try {
      if (showLoader) {
        isLoading = true;
      } else {
        isSearching = true;
      }
      notifyListeners();

      final response = await _repository.getMyCrew(search: search);

      workers = response.workers;
      total = response.total;
    } catch (e) {
      NotifySnackBar.show(
        e.toString().replaceFirst("Exception: ", ""),
        SnackBarType.Fail,
      );
    } finally {
      isLoading = false;
      isSearching = false;
      notifyListeners();
    }
  }

  void onSearchChanged(String value) {
    notifyListeners();
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      fetchMyCrew(
        search: value.trim().isEmpty ? null : value.trim(),
        showLoader: false,
      );
    });
  }

  void clearSearch() {
    searchController.clear();
    fetchMyCrew();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }
}