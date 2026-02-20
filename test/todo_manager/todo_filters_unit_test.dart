import 'package:flutter_test/flutter_test.dart';
import 'package:todo_demo/todo_manager/services/todo_data_source.dart';
import 'package:todo_demo/todo_manager/models/todo.dart';
import 'package:todo_demo/todo_manager/models/todo_filters.dart';

void main() {
  group('TodoFilters', () {
    test('defaults are set correctly', () {
      const filters = TodoFilters();

      expect(filters.isCompleted, isNull);
      expect(filters.priority, isNull);
      expect(filters.tag, isNull);
      expect(filters.sortBy, TodoSortBy.createdAt);
      expect(filters.sortAscending, isTrue);
    });

    test('copyWith updates only provided fields', () {
      const filters = TodoFilters();

      final updated = filters.copyWith(
        isCompleted: true,
        priority: TodoPriority.high,
        tag: 'work',
        sortBy: TodoSortBy.priority,
        sortAscending: false,
      );

      expect(updated.isCompleted, isTrue);
      expect(updated.priority, TodoPriority.high);
      expect(updated.tag, 'work');
      expect(updated.sortBy, TodoSortBy.priority);
      expect(updated.sortAscending, isFalse);
    });

    test('equality is based on values', () {
      const a = TodoFilters(
        isCompleted: false,
        priority: TodoPriority.low,
        tag: 'home',
        sortBy: TodoSortBy.dueDate,
        sortAscending: false,
      );
      const b = TodoFilters(
        isCompleted: false,
        priority: TodoPriority.low,
        tag: 'home',
        sortBy: TodoSortBy.dueDate,
        sortAscending: false,
      );
      const c = TodoFilters(
        isCompleted: true,
        priority: TodoPriority.low,
        tag: 'home',
        sortBy: TodoSortBy.dueDate,
        sortAscending: false,
      );

      expect(a, equals(b));
      expect(a, isNot(equals(c)));
    });
  });
}
