import '../models/todo.dart';
import '../models/todo_filters.dart';
import 'todo_data_source.dart';

class TodoFilterService {
  const TodoFilterService();

  String? buildWhereClause(TodoFilters filters) {
    final conditions = <String>[];

    if (filters.isCompleted != null) {
      conditions.add('${TodoFields.isCompleted} = ?');
    }

    if (filters.priority != null) {
      conditions.add('${TodoFields.priority} = ?');
    }

    if (filters.tag != null && filters.tag!.isNotEmpty) {
      conditions.add('${TodoFields.tags} LIKE ?');
    }

    if (conditions.isEmpty) {
      return null;
    }

    return conditions.join(' AND ');
  }

  List<Object?> buildWhereArgs(TodoFilters filters) {
    final args = <Object?>[];

    if (filters.isCompleted != null) {
      args.add(filters.isCompleted! ? 1 : 0);
    }

    if (filters.priority != null) {
      args.add(filters.priority!.index);
    }

    if (filters.tag != null && filters.tag!.isNotEmpty) {
      args.add('%"${filters.tag}"%');
    }

    return args;
  }

  String buildOrderBy(TodoFilters filters) {
    final direction = filters.sortAscending ? 'ASC' : 'DESC';
    switch (filters.sortBy) {
      case TodoSortBy.dueDate:
        return '${TodoFields.dueDate} IS NULL, ${TodoFields.dueDate} $direction';
      case TodoSortBy.priority:
        return '${TodoFields.priority} $direction';
      case TodoSortBy.createdAt:
        return '${TodoFields.createdAt} $direction';
    }
  }
}
