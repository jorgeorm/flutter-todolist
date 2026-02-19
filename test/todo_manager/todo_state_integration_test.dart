import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_demo/todo_manager/todo.dart';
import 'package:todo_demo/todo_manager/todo_database.dart';
import 'package:todo_demo/todo_manager/todo_repository.dart';
import 'package:todo_demo/todo_manager/todo_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  late TodoState state;

  setUp(() async {
    final db = await TodoDatabase.openInMemory(databaseFactoryFfi);
    final repository = TodoRepository(database: db);
    state = TodoState(repository: repository);
  });

  tearDown(() async {
    await state.dispose();
  });

  test('loadTodos populates items', () async {
    final now = DateTime(2026, 2, 6, 10, 30);
    await state.addTodo(
      Todo(
        title: 'Plan trip',
        tags: const ['travel'],
        priority: TodoPriority.medium,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await state.loadTodos();

    expect(state.todos, hasLength(1));
    expect(state.todos.first.title, 'Plan trip');
  });

  test('toggleComplete updates todo and list', () async {
    final now = DateTime(2026, 2, 6, 10, 30);
    final todo = Todo(
      title: 'Call bank',
      tags: const ['finance'],
      priority: TodoPriority.high,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    await state.addTodo(todo);
    await state.loadTodos();

    final first = state.todos.first;
    await state.toggleComplete(first, true);

    expect(state.todos.first.isCompleted, isTrue);
  });

  test('filters update results', () async {
    final now = DateTime(2026, 2, 6, 10, 30);
    await state.addTodo(
      Todo(
        title: 'Home task',
        tags: const ['home'],
        priority: TodoPriority.low,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    );
    await state.addTodo(
      Todo(
        title: 'Work task',
        tags: const ['work'],
        priority: TodoPriority.high,
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      ),
    );

    await state.setFilters(
      isCompleted: true,
      priority: null,
      tag: null,
      sortBy: TodoSortBy.createdAt,
      sortAscending: true,
    );

    expect(state.todos, hasLength(1));
    expect(state.todos.first.title, 'Work task');
  });
}
