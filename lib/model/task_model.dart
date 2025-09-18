import "package:hive/hive.dart";

/// Represents the status of a task.
enum TaskStatus {
  /// The task is pending.
  pending,

  /// The task is completed.
  completed,
}

/// Represents a task with a title and status.
class TaskModel {
  /// Creates a Task with the given title and status.
  TaskModel({required this.title, String? id, TaskStatus? status})
    : id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      status = status ?? TaskStatus.pending;

  /// Creates a Task from a JSON representation.
  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json["id"] as String,
    title: json["title"] as String,
    status: TaskStatus.values.firstWhere(
      (TaskStatus e) => e.toString() == 'TaskStatus.${json['status']}',
      orElse: () => TaskStatus.pending,
    ),
  );

  /// Converts the task to a JSON representation.
  Map<String, dynamic> toJson() => <String, dynamic>{
    "id": id,
    "title": title,
    "status": status.toString().split(".").last,
  };

  /// Unique identifier for the task.
  final String id;

  /// The title of the task.
  final String title;

  /// The status of the task.
  final TaskStatus status;

  /// Creates a copy of this task with the given status.
  TaskModel copyWith({String? title, TaskStatus? status}) => TaskModel(
    id: id,
    title: title ?? this.title,
    status: status ?? this.status,
  );

  @override
  String toString() => "Task(id: $id, title: $title, status: $status)";
}

/// Adapter for TaskModel to be used with Hive.
class TaskModelAdapter extends TypeAdapter<TaskModel> {
  @override
  final int typeId = 1;

  @override
  TaskModel read(BinaryReader reader) {
    final int numOfFields = reader.readByte();
    final Map<int, dynamic> fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TaskModel(
      id: fields[0] as String,
      title: fields[1] as String,
      status: fields[2] as TaskStatus,
    );
  }

  @override
  void write(BinaryWriter writer, TaskModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.status);
  }
}

/// Adapter for TaskStatus to be used with Hive.
class TaskStatusAdapter extends TypeAdapter<TaskStatus> {
  @override
  final int typeId = 2;

  @override
  TaskStatus read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return TaskStatus.pending;
      case 1:
        return TaskStatus.completed;
      default:
        return TaskStatus.pending;
    }
  }

  @override
  void write(BinaryWriter writer, TaskStatus obj) {
    switch (obj) {
      case TaskStatus.pending:
        writer.writeByte(0);
      case TaskStatus.completed:
        writer.writeByte(1);
    }
  }
}
