import "package:copilot_poc/model/task_model.dart";
import "package:hive_flutter/hive_flutter.dart";

/// This service handles local storage operations.
class HiveService<T> {
  /// Factory constructor to return the singleton instance per type.
  factory HiveService() => HiveService._getInstance<T>();

  /// Default constructor.
  HiveService._internal();

  static final Map<Type, HiveService<dynamic>> _instances =
      <Type, HiveService<dynamic>>{};

  static HiveService<T> _getInstance<T>() {
    if (!_instances.containsKey(T)) {
      _instances[T] = HiveService<T>._internal();
    }
    return _instances[T]! as HiveService<T>;
  }

  /// The box used for local storage.
  late final Box<T> box;

  /// Initializes the local storage service.
  Future<void> init() async {
    Hive
      ..registerAdapter(TaskStatusAdapter())
      ..registerAdapter(TaskModelAdapter());
    await Hive.initFlutter();
    box = await Hive.openBox("copilot_poc");
  }

  /// Adds a value to the box with the given key.
  Future<void> add(String key, T value) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    await box.put(key, value);
  }

  /// Retrieves a value from the box by key.
  T? get(String key) => box.get(key);

  /// Updates a value in the box with the given key if it exists.
  Future<void> update(String key, T value) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (box.containsKey(key)) {
      await box.put(key, value);
    } else {
      throw Exception("Key '$key' does not exist in the box.");
    }
  }

  /// Deletes a value from the box by key.
  Future<void> delete(String key) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    await box.delete(key);
  }

  /// Retrieves all values from the box.
  List<T> getAll() => box.values.toList();
}
