import 'package:flutter_test/flutter_test.dart';
import 'package:todo_demo/todo_manager/services/todo_filter_service.dart';
import 'package:todo_demo/todo_manager/services/todo_data_source.dart';
import 'package:todo_demo/todo_manager/models/todo.dart';
import 'package:todo_demo/todo_manager/models/todo_filters.dart';

void main() {
  group('TodoFilterService', () {
    final service = TodoFilterService();

    test('buildWhereClause returns empty for default filters', () {
      const filters = TodoFilters();

      expect(service.buildWhereClause(filters), isNull);
      expect(service.buildWhereArgs(filters), isEmpty);
    });

    test('buildWhereClause handles completion, priority, and tag', () {
      const filters = TodoFilters(
        isCompleted: true,
        priority: TodoPriority.high,
        tag: 'work',
      );

      expect(
        service.buildWhereClause(filters),
        '${TodoFields.isCompleted} = ? AND ${TodoFields.priority} = ? AND ${TodoFields.tags} LIKE ?',
      );
      expect(service.buildWhereArgs(filters), [1, TodoPriority.high.index, '%"work"%']);
    });

    test('buildOrderBy handles due date with nulls last', () {
      const filters = TodoFilters(
        sortBy: TodoSortBy.dueDate,
        sortAscending: true,
      );

      expect(
        service.buildOrderBy(filters),
        '${TodoFields.dueDate} IS NULL, ${TodoFields.dueDate} ASC',
      );
    });

    test('buildOrderBy respects descending order', () {
      const filters = TodoFilters(
        sortBy: TodoSortBy.priority,
        sortAscending: false,
      );

      expect(
        service.buildOrderBy(filters),
        '${TodoFields.priority} DESC',
      );
    });
  });
}
