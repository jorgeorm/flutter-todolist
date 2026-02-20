import 'package:flutter_test/flutter_test.dart';
import 'package:todo_demo/todo_manager/models/todo.dart';

void main() {
  group('Todo model', () {
    test('toJson/fromJson round trip preserves fields', () {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todo = Todo(
        id: 7,
        title: 'Pay rent',
        notes: 'Before 5pm',
        tags: const ['finance', 'monthly'],
        dueDate: DateTime(2026, 2, 10),
        priority: TodoPriority.high,
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );

      final map = todo.toJson();
      final restored = Todo.fromJson(map);

      expect(restored, todo);
    });

    test('fromJson handles nullable fields safely', () {
      final now = DateTime(2026, 2, 6, 10, 30);
      final map = {
        'id': 1,
        'title': 'Check mail',
        'notes': null,
        'tags': null,
        'dueDate': null,
        'priority': TodoPriority.low.index,
        'isCompleted': false,
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      };

      final todo = Todo.fromJson(map);

      expect(todo.tags, isEmpty);
      expect(todo.dueDate, isNull);
      expect(todo.notes, isNull);
      expect(todo.priority, TodoPriority.low);
      expect(todo.isCompleted, isFalse);
    });

    test('copyWith updates only provided fields', () {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todo = Todo(
        id: 2,
        title: 'Write report',
        tags: const ['work'],
        priority: TodoPriority.medium,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      final updated = todo.copyWith(
        title: 'Write final report',
        isCompleted: true,
      );

      expect(updated.title, 'Write final report');
      expect(updated.isCompleted, isTrue);
      expect(updated.tags, todo.tags);
      expect(updated.createdAt, todo.createdAt);
    });

    test('priority clamps out of range values', () {
      final now = DateTime(2026, 2, 6, 10, 30);
      final map = {
        'id': 3,
        'title': 'Task',
        'priority': 99,
        'isCompleted': false,
        'createdAt': now.millisecondsSinceEpoch,
        'updatedAt': now.millisecondsSinceEpoch,
      };

      final todo = Todo.fromJson(map);

      expect(todo.priority, TodoPriority.medium);
    });
  });
}
