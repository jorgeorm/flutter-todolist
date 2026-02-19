import 'package:flutter/foundation.dart';

import 'todo.dart';
import 'todo_repository.dart';

class TodoState extends ChangeNotifier {
  TodoState({required this.repository});

  final TodoRepository repository;

  List<Todo> _todos = [];
  bool? _filterIsCompleted;
  TodoPriority? _filterPriority;
  String? _filterTag;
  TodoSortBy _sortBy = TodoSortBy.createdAt;
  bool _sortAscending = true;

  List<Todo> get todos => _todos;

  Future<void> loadTodos() async {
    _todos = await repository.fetchFiltered(
      isCompleted: _filterIsCompleted,
      priority: _filterPriority,
      tag: _filterTag,
      sortBy: _sortBy,
      sortAscending: _sortAscending,
    );
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await repository.insert(todo);
    await loadTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await repository.update(todo);
    await loadTodos();
  }

  Future<void> toggleComplete(Todo todo, bool isCompleted) async {
    final updated = todo.copyWith(
      isCompleted: isCompleted,
      updatedAt: DateTime.now(),
    );
    await repository.update(updated);
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await repository.delete(id);
    await loadTodos();
  }

  Future<void> setFilters({
    bool? isCompleted,
    TodoPriority? priority,
    String? tag,
    TodoSortBy sortBy = TodoSortBy.createdAt,
    bool sortAscending = true,
  }) async {
    _filterIsCompleted = isCompleted;
    _filterPriority = priority;
    _filterTag = tag;
    _sortBy = sortBy;
    _sortAscending = sortAscending;
    await loadTodos();
  }

  Future<void> clearFilters() async {
    _filterIsCompleted = null;
    _filterPriority = null;
    _filterTag = null;
    _sortBy = TodoSortBy.createdAt;
    _sortAscending = true;
    await loadTodos();
  }

  @override
  Future<void> dispose() async {
    await repository.close();
    super.dispose();
  }
}
