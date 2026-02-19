import 'package:sqflite/sqflite.dart';

import 'todo.dart';

enum TodoSortBy {
  dueDate,
  priority,
  createdAt,
}

class TodoRepository {
  TodoRepository({required this.database});

  final Database database;

  Future<int> insert(Todo todo) async {
    final data = todo.toJson()
      ..remove(TodoFields.id);
    return database.insert('todos', data);
  }

  Future<List<Todo>> fetchAll() {
    return fetchFiltered(
      sortBy: TodoSortBy.createdAt,
      sortAscending: false,
    );
  }

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

  Future<int> delete(int id) {
    return database.delete(
      'todos',
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<List<Todo>> fetchFiltered({
    bool? isCompleted,
    TodoPriority? priority,
    String? tag,
    TodoSortBy sortBy = TodoSortBy.createdAt,
    bool sortAscending = true,
  }) async {
    final where = <String>[];
    final args = <Object?>[];

    if (isCompleted != null) {
      where.add('${TodoFields.isCompleted} = ?');
      args.add(isCompleted ? 1 : 0);
    }

    if (priority != null) {
      where.add('${TodoFields.priority} = ?');
      args.add(priority.index);
    }

    if (tag != null && tag.isNotEmpty) {
      where.add('${TodoFields.tags} LIKE ?');
      args.add('%"$tag"%');
    }

    final rows = await database.query(
      'todos',
      where: where.isEmpty ? null : where.join(' AND '),
      whereArgs: args,
      orderBy: _orderBy(sortBy, sortAscending),
    );

    return rows.map(Todo.fromJson).toList();
  }

  Future<void> close() {
    return database.close();
  }

  String _orderBy(TodoSortBy sortBy, bool sortAscending) {
    final direction = sortAscending ? 'ASC' : 'DESC';
    switch (sortBy) {
      case TodoSortBy.dueDate:
        return '${TodoFields.dueDate} IS NULL, ${TodoFields.dueDate} $direction';
      case TodoSortBy.priority:
        return '${TodoFields.priority} $direction';
      case TodoSortBy.createdAt:
        return '${TodoFields.createdAt} $direction';
    }
  }
}
