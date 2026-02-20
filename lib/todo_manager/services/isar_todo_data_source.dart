import 'package:isar/isar.dart';

import '../models/todo_isar.dart';
import '../models/todo.dart';
import '../models/todo_filters.dart';
import 'todo_data_source.dart';
import 'todo_filter_service.dart';

/// Isar-based implementation of TodoDataSource.
///
/// This provides a high-performance NoSQL database backend for todos,
/// as an alternative to SQLite.
class IsarTodoDataSource implements TodoDataSource {
  IsarTodoDataSource({
    required this.isar,
    TodoFilterService? filterService,
  }) : filterService = filterService ?? const TodoFilterService();

  final Isar isar;
  final TodoFilterService filterService;

  @override
  Future<int> insert(Todo todo) async {
    final isarTodo = _fromDomain(todo);
    return isar.writeTxn(() async {
      return isar.todoIsars.put(isarTodo);
    });
  }

  @override
  Future<List<Todo>> fetchAll() {
    return fetchFiltered(
      const TodoFilters(
        sortBy: TodoSortBy.createdAt,
        sortAscending: false,
      ),
    );
  }

  @override
  Future<Todo?> fetchById(int id) async {
    final isarTodo = await isar.todoIsars.get(id);
    if (isarTodo == null) {
      return null;
    }
    return _toDomain(isarTodo);
  }

  @override
  Future<int> update(Todo todo) async {
    if (todo.id == null) {
      throw ArgumentError('Todo id is required for update.');
    }
    final isarTodo = _fromDomain(todo);
    return isar.writeTxn(() async {
      return (await isar.todoIsars.put(isarTodo)) > 0 ? 1 : 0;
    });
  }

  @override
  Future<int> delete(int id) async {
    return isar.writeTxn(() async {
      return (await isar.todoIsars.delete(id)) ? 1 : 0;
    });
  }

  @override
  Future<List<Todo>> fetchFiltered(TodoFilters filters) async {
    // Fetch all todos (optimized query with isCompleted index if available)
    List<TodoIsar> isarTodos;
    if (filters.isCompleted != null) {
      isarTodos = await isar.todoIsars
          .where()
          .isCompletedEqualTo(filters.isCompleted!)
          .findAll();
    } else {
      isarTodos = await isar.todoIsars.where().findAll();
    }

    // Apply priority filter in memory (no compound index)
    if (filters.priority != null) {
      final priorityInt = _priorityToInt(filters.priority!);
      isarTodos = isarTodos.where((t) => t.priority == priorityInt).toList();
    }

    // Apply tag filter in memory
    if (filters.tag != null) {
      isarTodos = isarTodos
          .where((todo) => todo.tags.contains(filters.tag!))
          .toList();
    }

    // Apply sorting
    isarTodos = _sortTodos(isarTodos, filters.sortBy, filters.sortAscending);

    return isarTodos.map(_toDomain).toList();
  }

  /// Sort a list of todos based on filters
  List<TodoIsar> _sortTodos(
    List<TodoIsar> todos,
    TodoSortBy sortBy,
    bool sortAscending,
  ) {
    switch (sortBy) {
      case TodoSortBy.createdAt:
        todos.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case TodoSortBy.dueDate:
        todos.sort((a, b) {
          // Handle nulls - put null dates at the end
          if (a.dueDate == null && b.dueDate == null) return 0;
          if (a.dueDate == null) return 1;
          if (b.dueDate == null) return -1;
          return a.dueDate!.compareTo(b.dueDate!);
        });
      case TodoSortBy.priority:
        todos.sort((a, b) => a.priority.compareTo(b.priority));
    }

    if (!sortAscending) {
      todos = todos.reversed.toList();
    }

    return todos;
  }

  @override
  Future<void> close() {
    return isar.close();
  }

  // Helper methods

  /// Convert domain Todo to Isar TodoIsar model.
  TodoIsar _fromDomain(Todo todo) {
    return TodoIsar(
      id: todo.id,
      title: todo.title,
      notes: todo.notes,
      isCompleted: todo.isCompleted,
      priority: _priorityToInt(todo.priority),
      tags: todo.tags,
      dueDate: todo.dueDate,
      createdAt: todo.createdAt ?? DateTime.now(),
      updatedAt: todo.updatedAt ?? DateTime.now(),
    );
  }

  /// Convert Isar TodoIsar model to domain Todo.
  Todo _toDomain(TodoIsar isarTodo) {
    return Todo(
      id: isarTodo.id,
      title: isarTodo.title,
      notes: isarTodo.notes,
      isCompleted: isarTodo.isCompleted,
      priority: _intToPriority(isarTodo.priority),
      tags: isarTodo.tags,
      dueDate: isarTodo.dueDate,
      createdAt: isarTodo.createdAt,
      updatedAt: isarTodo.updatedAt,
    );
  }

  /// Convert TodoPriority enum to integer for storage.
  int _priorityToInt(TodoPriority priority) {
    switch (priority) {
      case TodoPriority.low:
        return 0;
      case TodoPriority.medium:
        return 1;
      case TodoPriority.high:
        return 2;
    }
  }

  /// Convert integer back to TodoPriority enum.
  TodoPriority _intToPriority(int value) {
    switch (value) {
      case 0:
        return TodoPriority.low;
      case 1:
        return TodoPriority.medium;
      case 2:
        return TodoPriority.high;
      default:
        return TodoPriority.medium;
    }
  }
}
