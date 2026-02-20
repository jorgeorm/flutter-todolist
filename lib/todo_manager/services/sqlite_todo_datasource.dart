import 'package:sqflite/sqflite.dart';

import 'todo_data_source.dart';
import 'todo_filter_service.dart';
import '../models/todo_filters.dart';
import '../models/todo.dart';

class SqliteTodoDatasource implements TodoDataSource {
  SqliteTodoDatasource({
    required this.database,
    TodoFilterService? filterService,
  }) : filterService = filterService ?? const TodoFilterService();

  final Database database;
  final TodoFilterService filterService;

  @override
  Future<int> insert(Todo todo) async {
    final data = todo.toJson()
      ..remove(TodoFields.id);
    return database.insert('todos', data);
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
    final rows = await database.query(
      'todos',
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
      limit: 1,
    );
    if (rows.isEmpty) {
      return null;
    }
    return Todo.fromJson(rows.first);
  }

  @override
  Future<int> update(Todo todo) async {
    final id = todo.id;
    if (id == null) {
      throw ArgumentError('Todo id is required for update.');
    }
    final data = todo.toJson()
      ..remove(TodoFields.id);
    return database.update(
      'todos',
      data,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<int> delete(int id) {
    return database.delete(
      'todos',
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  @override
  Future<List<Todo>> fetchFiltered(TodoFilters filters) async {
    final whereClause = filterService.buildWhereClause(filters);
    final args = filterService.buildWhereArgs(filters);

    final rows = await database.query(
      'todos',
      where: whereClause,
      whereArgs: args,
      orderBy: filterService.buildOrderBy(filters),
    );

    return rows.map(Todo.fromJson).toList();
  }

  @override
  Future<void> close() {
    return database.close();
  }

  
}
