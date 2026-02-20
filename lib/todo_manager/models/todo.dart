import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';

import '../../shared/milliseconds_converter.dart';
import '../../shared/sqlite_boolean_converter.dart';
part 'todo.freezed.dart';
part 'todo.g.dart';

enum TodoPriority {
  low,
  medium,
  high,
}

@freezed
class Todo with _$Todo {
  const Todo._();

  const factory Todo({
    int? id,
    required String title,
    String? notes,
    @JsonKey(fromJson: _tagsFromJson, toJson: _tagsToJson)
    @Default([])
    List<String> tags,
    @JsonKey(name: TodoFields.dueDate)
    @MillisecondsConverter() DateTime? dueDate,
    @JsonKey(fromJson: _priorityFromDb, toJson: _priorityToDb)
    @Default(TodoPriority.medium) TodoPriority priority,
    @SqliteBooleanConverter()
    @JsonKey(name: TodoFields.isCompleted)
    @Default(false) bool isCompleted,
    @MillisecondsConverter()
    @JsonKey(name: TodoFields.createdAt)
    DateTime? createdAt,
    @MillisecondsConverter()
    @JsonKey(name: TodoFields.updatedAt)
    DateTime? updatedAt,
  }) = _Todo;

  factory Todo.fromJson(Map<String, dynamic> json) =>
      _$TodoFromJson(json);

}

List<String> _tagsFromJson(String json) {
  if (json.isEmpty) return [];
  
  return jsonDecode(json).cast<String>();
}

String? _tagsToJson(List<String> tags) {
  return jsonEncode(tags);
}

TodoPriority _priorityFromDb(int value) {
  if (value >= 0 && value < TodoPriority.values.length) {
    // Handle string enum names
    return TodoPriority.values.firstWhere(
      (e) => e.index == value,
      orElse: () => TodoPriority.medium,
    );
  }
  return TodoPriority.medium;
}

int _priorityToDb(TodoPriority priority) => priority.index;

class TodoFields {
  static const String id = 'id';
  static const String title = 'title';
  static const String notes = 'notes';
  static const String tags = 'tags';
  static const String dueDate = 'due_date';
  static const String priority = 'priority';
  static const String isCompleted = 'is_completed';
  static const String createdAt = 'created_at';
  static const String updatedAt = 'updated_at';
}
