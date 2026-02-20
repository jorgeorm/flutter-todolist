import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:todo_demo/todo_manager/models/todo_isar.dart';
import 'package:todo_demo/todo_manager/services/isar_todo_data_source.dart';
import 'package:todo_demo/todo_manager/models/todo.dart';
import 'package:todo_demo/todo_manager/models/todo_filters.dart';

@Tags(['isar'])
void main() {
  group('IsarTodoDataSource integration tests', () {
    Isar? isarDb;
    late IsarTodoDataSource dataSource;
    late Directory tempDir;

    setUpAll(() async {
      // Ensure the native core is available in VM tests.
      await Isar.initializeIsarCore(download: true);
    });

    setUp(() async {
      tempDir = await Directory.systemTemp.createTemp('isar_test_');
      isarDb = await Isar.open(
        [TodoIsarSchema],
        directory: tempDir.path,
        inspector: false,
      );
      dataSource = IsarTodoDataSource(isar: isarDb!);
    });

    tearDown(() async {
      if (isarDb?.isOpen ?? false) {
        await isarDb?.close();
      }
      await tempDir.delete(recursive: true);
    });

    test('can create and store a todo', () async {
      // Arrange
      final todo = Todo(
        title: 'Test Todo',
        notes: 'Test notes',
        tags: ['tag1'],
        priority: TodoPriority.high,
        dueDate: DateTime(2026, 12, 31),
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      // Act
      final id = await dataSource.insert(todo);

      // Assert
      expect(id, isNotNull);
      expect(id, greaterThan(0));
    });

    test('can fetch all todos', () async {
      // Arrange
      final todo1 = Todo(
        title: 'Todo 1',
        notes: null,
        tags: [],
        priority: TodoPriority.medium,
        dueDate: null,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final todo2 = Todo(
        title: 'Todo 2',
        notes: null,
        tags: [],
        priority: TodoPriority.low,
        dueDate: null,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      await dataSource.insert(todo1);
      await dataSource.insert(todo2);

      // Act
      final todos = await dataSource.fetchAll();

      // Assert
      expect(todos, hasLength(2));
    });

    test('can fetch todo by id', () async {
      // Arrange
      final todo = Todo(
        title: 'Test Todo',
        notes: null,
        tags: [],
        priority: TodoPriority.medium,
        dueDate: null,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final id = await dataSource.insert(todo);

      // Act
      final fetched = await dataSource.fetchById(id);

      // Assert
      expect(fetched, isNotNull);
      expect(fetched!.title, equals('Test Todo'));
    });

    test('can update todo', () async {
      // Arrange
      final original = Todo(
        title: 'Original Title',
        notes: null,
        tags: [],
        priority: TodoPriority.low,
        dueDate: null,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final id = await dataSource.insert(original);

      // Act
      final updated = Todo(
        id: id,
        title: 'Updated Title',
        notes: 'New notes',
        tags: ['updated'],
        priority: TodoPriority.high,
        dueDate: null,
        isCompleted: true,
        createdAt: original.createdAt,
        updatedAt: DateTime.now(),
      );
      await dataSource.update(updated);
      final fetched = await dataSource.fetchById(id);

      // Assert
      expect(fetched!.title, equals('Updated Title'));
      expect(fetched.isCompleted, isTrue);
    });

    test('can delete todo', () async {
      // Arrange
      final todo = Todo(
        title: 'Todo to delete',
        notes: null,
        tags: [],
        priority: TodoPriority.medium,
        dueDate: null,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final id = await dataSource.insert(todo);

      // Act
      await dataSource.delete(id);
      final fetched = await dataSource.fetchById(id);

      // Assert
      expect(fetched, isNull);
    });

    test('fetchFiltered returns todos matching filter criteria', () async {
      // Arrange
      final completed = Todo(
        title: 'Completed Todo',
        notes: null,
        tags: ['work'],
        priority: TodoPriority.high,
        dueDate: null,
        isCompleted: true,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      final active = Todo(
        title: 'Active Todo',
        notes: null,
        tags: ['work'],
        priority: TodoPriority.low,
        dueDate: null,
        isCompleted: false,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await dataSource.insert(completed);
      await dataSource.insert(active);

      // Act
      final filters = const TodoFilters(isCompleted: true);
      final results = await dataSource.fetchFiltered(filters);

      // Assert
      expect(results, hasLength(1));
      expect(results.first.isCompleted, isTrue);
    });

    test('can close database connection', () async {
      // Act & Assert - should not throw
      await dataSource.close();
    });
  });
}
