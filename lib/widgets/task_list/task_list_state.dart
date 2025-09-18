import "package:copilot_poc/model/task_model.dart";
import "package:equatable/equatable.dart";

/// Represents the status of the task list.
enum TaskListStateStatus {
  /// The initial state of the task list.
  initial,

  /// The task list is currently loading.
  loading,

  /// The task list has been successfully loaded.
  loaded,

  /// An error occurred while loading the task list.
  error,
}

/// Represents the state of the task list.
class TaskListState extends Equatable {
  /// Creates a TaskListState with a list of tasks.
  const TaskListState({
    required this.tasks,
    this.status = TaskListStateStatus.initial,
  });

  /// The status of the task list.
  final TaskListStateStatus status;

  /// The list of tasks.
  final List<TaskModel> tasks;

  /// Creates a copy of this state with the given tasks.
  TaskListState copyWith({
    TaskListStateStatus? status,
    List<TaskModel>? tasks,
  }) =>
      TaskListState(status: status ?? this.status, tasks: tasks ?? this.tasks);

  @override
  List<Object> get props => <Object>[status, tasks];
}
