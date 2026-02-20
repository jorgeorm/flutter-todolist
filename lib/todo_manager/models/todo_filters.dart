import 'package:freezed_annotation/freezed_annotation.dart';

import '../services/todo_data_source.dart';
import 'todo.dart';

part 'todo_filters.freezed.dart';

@freezed
class TodoFilters with _$TodoFilters {
  const factory TodoFilters({
    bool? isCompleted,
    TodoPriority? priority,
    String? tag,
    @Default(TodoSortBy.createdAt) TodoSortBy sortBy,
    @Default(true) bool sortAscending,
  }) = _TodoFilters;
}
