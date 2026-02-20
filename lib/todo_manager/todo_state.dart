import 'package:flutter/foundation.dart';

import 'services/todo_data_source.dart';
import 'models/todo.dart';
import 'models/todo_filters.dart';

class TodoState extends ChangeNotifier {
  TodoState({required this.dataSource});

  final TodoDataSource dataSource;

  List<Todo> _todos = [];
  TodoFilters _filters = const TodoFilters();

  List<Todo> get todos => _todos;

  TodoFilters get filters => _filters;

  Future<void> loadTodos() async {
    _todos = await dataSource.fetchFiltered(_filters);
    notifyListeners();
  }

  Future<void> addTodo(Todo todo) async {
    await dataSource.insert(todo);
    await loadTodos();
  }

  Future<void> updateTodo(Todo todo) async {
    await dataSource.update(todo);
    await loadTodos();
  }

  Future<void> toggleComplete(Todo todo, bool isCompleted) async {
    final updated = todo.copyWith(
      isCompleted: isCompleted,
      updatedAt: DateTime.now(),
    );
    await dataSource.update(updated);
    await loadTodos();
  }

  Future<void> deleteTodo(int id) async {
    await dataSource.delete(id);
    await loadTodos();
  }

  Future<void> setFilters(TodoFilters filters) async {
    _filters = filters;
    await loadTodos();
  }

  Future<void> clearFilters() async {
    _filters = const TodoFilters();
    await loadTodos();
  }

  @override
  Future<void> dispose() async {
    await dataSource.close();
    super.dispose();
  }
}
