import "package:copilot_poc/model/task_model.dart";
import "package:copilot_poc/service/hive_service.dart";

/// This class provides a local data source for tasks using the LocalStorageService.
class TaskLocalDatasource {
  /// Creates a TaskLocalDatasource with a local storage service.
  TaskLocalDatasource({required this.localStorageService});

  /// The local storage service for tasks.
  final HiveService<TaskModel> localStorageService;

  /// Fetches tasks from the local storage.
  List<TaskModel> fetchTasks() => localStorageService.getAll();

  /// Adds a task to the local storage.
  Future<void> add(TaskModel task) async {
    await localStorageService.add(task.id, task);
  }

  /// Updates a task in the local storage.
  Future<void> update(TaskModel task) async {
    await localStorageService.update(task.id, task);
  }

  /// Removes a task from the local storage by its ID.
  Future<void> removeTask(String id) async {
    await localStorageService.delete(id);
  }
}
