import 'package:todo_demo/todo_manager/models/todo_filters.dart';

import '../models/todo.dart';

/// Abstract interface for todo data persistence.
/// 
/// Allows swappable implementations (SQLite, Hive, Firestore, API, etc).
abstract class TodoDataSource {
  /// Insert a new todo and return its ID.
  Future<int> insert(Todo todo);
  /// Fetch all todos with optional filtering and sorting.
  ///
  /// Parameters:
  /// - [isCompleted]: Filter by completion status. Null = no filter.
  /// - [priority]: Filter by priority. Null = no filter.
  /// - [tag]: Filter by tag (exact match). Null = no filter.
  /// - [sortBy]: Sort by this field (default: createdAt).
  /// - [sortAscending]: Sort direction (default: true).
  Future<List<Todo>> fetchFiltered(TodoFilters filters);

  /// Fetch a single todo by ID.
  Future<Todo?> fetchById(int id);

  /// Fetch all todos (default sort order).
  Future<List<Todo>> fetchAll() => fetchFiltered(
    const TodoFilters(
      sortBy: TodoSortBy.createdAt,
      sortAscending: false,
    ),
  );

  /// Update an existing todo.
  Future<int> update(Todo todo);

  /// Delete a todo by ID.
  Future<int> delete(int id);

  /// Close and cleanup resources.
  Future<void> close();
}

enum TodoSortBy {
  dueDate,
  priority,
  createdAt,
}
