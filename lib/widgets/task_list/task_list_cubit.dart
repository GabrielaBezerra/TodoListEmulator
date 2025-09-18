import "package:bloc/bloc.dart";
import "package:copilot_poc/model/task_model.dart";
import "package:copilot_poc/repository/task_list_repository.dart";
import "package:copilot_poc/widgets/task_list/task_list_state.dart";

/// Manages the state of the task list.
class TaskListCubit extends Cubit<TaskListState> {
  /// Creates a TaskListCubit with a given repository.
  TaskListCubit({required this.repository})
    : super(const TaskListState(tasks: <TaskModel>[]));

  /// The repository used to fetch tasks.
  final TaskRepository repository;

  /// Fetches tasks from the repository and emits the list.
  void fetchTasks() {
    emit(state.copyWith(status: TaskListStateStatus.loading));
    repository.fetchTasks().fold(
      (Exception error) =>
          emit(state.copyWith(status: TaskListStateStatus.error)),
      (List<TaskModel> tasks) => emit(
        state.copyWith(status: TaskListStateStatus.loaded, tasks: tasks),
      ),
    );
  }

  /// Adds a task to the list.
  Future<void> add(String task) async {
    emit(state.copyWith(status: TaskListStateStatus.loading));
    (await repository.add(TaskModel(title: task))).fold(
      (Exception error) =>
          emit(state.copyWith(status: TaskListStateStatus.error)),
      (_) => fetchTasks(),
    );
  }

  /// Removes a task from the list.
  Future<void> remove(TaskModel task) async {
    emit(state.copyWith(status: TaskListStateStatus.loading));
    (await repository.remove(task.id)).fold(
      (Exception error) =>
          emit(state.copyWith(status: TaskListStateStatus.error)),
      (_) => fetchTasks(),
    );
  }

  /// Toggles the status of a task to completed.
  Future<void> check(TaskModel task) async {
    emit(state.copyWith(status: TaskListStateStatus.loading));
    final TaskModel completedTask = task.copyWith(
      status:
          task.status == TaskStatus.completed
              ? TaskStatus.pending
              : TaskStatus.completed,
    );
    (await repository.update(completedTask)).fold(
      (Exception error) =>
          emit(state.copyWith(status: TaskListStateStatus.error)),
      (_) => fetchTasks(),
    );
  }

  /// Throws an error for demonstration purposes.
  void throwErrorForDemonstration() {
    emit(state.copyWith(status: TaskListStateStatus.loading));
    emit(state.copyWith(status: TaskListStateStatus.error));
  }
}
