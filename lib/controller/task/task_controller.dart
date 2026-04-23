import 'package:flutter/material.dart';
import 'package:safety_management/repository/task/task_repository.dart';
import 'package:safety_management/utils/notify_snackbar.dart';
import '../../model/task/task_model.dart';

class TaskController extends ChangeNotifier {
  final TaskRepository _repository = TaskRepository();

  List<TaskModel> _tasks = [];
  bool isLoading = false;

  List<TaskModel> get tasks => _tasks;

  Future<void> fetchTasks() async {
    try {
      isLoading = true;
      notifyListeners();
      _tasks = await _repository.getTasks();
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

  List<TaskModel> getTasksByStatus(String? status) {
    if (status == null || status.toLowerCase() == 'all') return _tasks;
    return _tasks
        .where((task) => task.status.toLowerCase() == status.toLowerCase())
        .toList();
  }

  Future<void> addTask(TaskModel task) async {
    try {
      isLoading = true;
      notifyListeners();
      final newTask = await _repository.createTask(task);
      _tasks.add(newTask);
      NotifySnackBar.show("Task created successfully", SnackBarType.success);
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

  Future<void> deleteTask(int id) async {
    try {
      isLoading = true;
      notifyListeners();
      await _repository.deleteTask(id);
      _tasks.removeWhere((task) => task.id == id);
      NotifySnackBar.show("Task deleted successfully", SnackBarType.success);
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
