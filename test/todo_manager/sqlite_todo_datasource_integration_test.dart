import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_demo/todo_manager/services/todo_data_source.dart';
import 'package:todo_demo/todo_manager/models/todo.dart';
import 'package:todo_demo/todo_manager/todo_sqlitedb.dart';
import 'package:todo_demo/todo_manager/models/todo_filters.dart';
import 'package:todo_demo/todo_manager/services/sqlite_todo_datasource.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  late SqliteTodoDatasource repository;

  setUp(() async {
    final db = await TodoSqliteDb.openInMemory(databaseFactoryFfi);
    repository = SqliteTodoDatasource(database: db);
  });

  tearDown(() async {
    await repository.close();
  });

  group('SqliteTodoDatasource integration tests', () {
    test('create and fetch all todos', () async {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todo = Todo(
        title: 'Pay rent',
        notes: 'Before 5pm',
        tags: const ['finance'],
        dueDate: DateTime(2026, 2, 10),
        priority: TodoPriority.high,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final id = await repository.insert(todo);
      final todos = await repository.fetchAll();

      expect(todos, hasLength(1));
      expect(todos.first.id, id);
      expect(todos.first.title, todo.title);
    });

    test('update todo and fetch by id', () async {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todo = Todo(
        title: 'Grocery run',
        tags: const ['home'],
        priority: TodoPriority.low,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final id = await repository.insert(todo);
      final updated = todo.copyWith(
        id: id,
        title: 'Grocery run (updated)',
        isCompleted: true,
        updatedAt: now.add(const Duration(hours: 1)),
      );

      await repository.update(updated);
      final fetched = await repository.fetchById(id);

      expect(fetched?.title, updated.title);
      expect(fetched?.isCompleted, isTrue);
    });

    test('delete removes todo', () async {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todo = Todo(
        title: 'Call mom',
        tags: const ['family'],
        priority: TodoPriority.medium,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final id = await repository.insert(todo);
      await repository.delete(id);

      final todos = await repository.fetchAll();
      expect(todos, isEmpty);
    });

    test('filters by completion, priority, tag, and sort', () async {
      final base = DateTime(2026, 2, 6, 10, 30);
      final todos = <Todo>[
        Todo(
          title: 'A',
          tags: const ['home'],
          dueDate: base.add(const Duration(days: 2)),
          priority: TodoPriority.low,
          isCompleted: false,
          createdAt: base,
          updatedAt: base,
        ),
        Todo(
          title: 'B',
          tags: const ['work'],
          dueDate: base.add(const Duration(days: 1)),
          priority: TodoPriority.high,
          isCompleted: true,
          createdAt: base,
          updatedAt: base,
        ),
        Todo(
          title: 'C',
          tags: const ['work'],
          dueDate: base.add(const Duration(days: 3)),
          priority: TodoPriority.medium,
          isCompleted: false,
          createdAt: base,
          updatedAt: base,
        ),
      ];

      for (final todo in todos) {
        await repository.insert(todo);
      }

      const filters = TodoFilters(
        isCompleted: false,
        priority: TodoPriority.medium,
        tag: 'work',
        sortBy: TodoSortBy.dueDate,
        sortAscending: true,
      );

      final filtered = await repository.fetchFiltered(filters);

      expect(filtered, hasLength(1));
      expect(filtered.first.title, 'C');

      const sortFilters = TodoFilters(
        sortBy: TodoSortBy.priority,
        sortAscending: false,
      );

      final sorted = await repository.fetchFiltered(sortFilters);

      expect(sorted.first.priority, TodoPriority.high);
    });
  });
}
