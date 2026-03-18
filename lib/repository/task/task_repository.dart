import 'package:dio/dio.dart';
import 'package:safety_management/model/task/task_model.dart';
import 'package:safety_management/network/api_endpoints.dart';
import 'package:safety_management/network/api_providers.dart';

class TaskRepository {
  final ApiProvider _apiProvider = ApiProvider();

  Future<List<TaskModel>> getTasks() async {
    try {
      final response = await _apiProvider.get(
        ApiEndpoint.tasks,
        requiresAuth: true,
      );

      if (response == null) {
        return [];
      }

      if (response is List) {
        return response.map((item) => TaskModel.fromJson(item)).toList();
      }

      return [];
    } on DioException catch (e) {
      _handleDioError(e, "Unable to fetch tasks");
      rethrow;
    } catch (e) {
      throw Exception("Unable to fetch tasks");
    }
  }

  Future<TaskModel> createTask(TaskModel task) async {
    try {
      final response = await _apiProvider.post(
        ApiEndpoint.tasks,
        body: task.toJson(),
        requiresAuth: true,
      );

      if (response == null) {
        throw Exception("No response from server");
      }

      if (response is Map<String, dynamic>) {
        return TaskModel.fromJson(response);
      }

      throw Exception("Unable to create task");
    } on DioException catch (e) {
      _handleDioError(e, "Unable to create task");
      rethrow;
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteTask(int taskId) async {
    try {
      await _apiProvider.delete(
        "${ApiEndpoint.tasks}$taskId",
        requiresAuth: true,
      );
    } on DioException catch (e) {
      _handleDioError(e, "Unable to delete task");
      rethrow;
    } catch (e) {
      throw Exception("Unable to delete task");
    }
  }

  void _handleDioError(DioException e, String defaultMessage) {
    final data = e.response?.data;
    if (data is Map<String, dynamic>) {
      final detail = data['detail'];
      if (detail != null && detail.toString().trim().isNotEmpty) {
        throw Exception(detail.toString());
      }
    }
    throw Exception(defaultMessage);
  }
}
