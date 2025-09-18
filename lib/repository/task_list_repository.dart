import "package:copilot_poc/model/task_model.dart";
import "package:copilot_poc/repository/data/task_local_datasource.dart";
import "package:dartz/dartz.dart";
import "package:logger/logger.dart";

/// Manages the task data.
class TaskRepository {
  /// Creates a TaskRepository with optional local and remote data sources.
  TaskRepository({required this.localDatasource});

  /// The local data source for tasks.
  TaskLocalDatasource localDatasource;

  /// Fetches tasks from a data source.
  Either<Exception, List<TaskModel>> fetchTasks() {
    try {
      final List<TaskModel> localTasks = localDatasource.fetchTasks();
      return Right<Exception, List<TaskModel>>(localTasks);
    } on Object catch (e) {
      Logger().e("Error fetching tasks: $e");
      return Left<Exception, List<TaskModel>>(
        Exception("Failed to fetch tasks"),
      );
    }
  }

  /// Adds a task to the local data source.
  Future<Either<Exception, void>> add(TaskModel task) async {
    try {
      await localDatasource.add(task);
      return Right<Exception, TaskModel>(task);
    } on Object catch (e) {
      Logger().e("Error adding task: $e");
      return Left<Exception, TaskModel>(Exception("Failed to add task"));
    }
  }

  /// Updates a task in the local data source.
  Future<Either<Exception, void>> update(TaskModel task) async {
    try {
      await localDatasource.update(task);
      return const Right<Exception, void>(null);
    } on Object catch (e) {
      Logger().e("Error updating task: $e");
      return Left<Exception, void>(Exception("Failed to update task"));
    }
  }

  /// Removes a task from the local data source.
  Future<Either<Exception, void>> remove(String id) async {
    try {
      await localDatasource.removeTask(id);
      return const Right<Exception, void>(null);
    } on Object catch (e) {
      Logger().e("Error removing task: $e");
      return Left<Exception, void>(Exception("Failed to remove task"));
    }
  }
}
