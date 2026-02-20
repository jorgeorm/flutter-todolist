import 'package:isar/isar.dart';

part 'todo_isar.g.dart';

@Collection()
class TodoIsar {
  TodoIsar({
    this.id,
    required this.title,
    this.notes,
    required this.isCompleted,
    required this.priority,
    required this.tags,
    this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  Id? id;

  @Index()
  final String title;

  final String? notes;

  @Index()
  final bool isCompleted;

  @Index()
  final int priority; // 0 = low, 1 = medium, 2 = high

  final List<String> tags;

  @Index()
  final DateTime? dueDate;

  @Index()
  final DateTime createdAt;

  final DateTime updatedAt;
}
