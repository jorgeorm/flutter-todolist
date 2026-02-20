import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_demo/todo_manager/services/todo_data_source.dart';
import 'package:todo_demo/todo_manager/models/todo.dart';
import 'package:todo_demo/todo_manager/models/todo_filters.dart';
import 'package:todo_demo/todo_manager/todo_state.dart';

class MockTodoDataSource extends Mock implements TodoDataSource {}

void main() {
  late MockTodoDataSource mockDataSource;
  late TodoState state;

  setUpAll(() {
    // Register fallback values for any types used in matchers
    registerFallbackValue(
      Todo(title: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    );
    registerFallbackValue(const TodoFilters());
    registerFallbackValue(TodoSortBy.createdAt);
    registerFallbackValue(TodoPriority.medium);
  });

  setUp(() {
    mockDataSource = MockTodoDataSource();
    state = TodoState(dataSource: mockDataSource);
  });

  group('TodoState with mocks', () {
    test('loadTodos fetches from dataSource and notifies listeners', () async {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todos = [
        Todo(
          id: 1,
          title: 'Plan trip',
          tags: const ['travel'],
          priority: TodoPriority.medium,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      when(
        () => mockDataSource.fetchFiltered(any()),
      ).thenAnswer((_) async => todos);

      var listenerCalled = false;
      state.addListener(() {
        listenerCalled = true;
      });

      await state.loadTodos();

      expect(state.todos, hasLength(1));
      expect(state.todos.first.title, 'Plan trip');
      expect(listenerCalled, isTrue);
      verify(
        () => mockDataSource.fetchFiltered(const TodoFilters()),
      ).called(1);
    });

    test('addTodo inserts and reloads', () async {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todo = Todo(
        title: 'New task',
        tags: const ['work'],
        priority: TodoPriority.high,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockDataSource.insert(any())).thenAnswer((_) async => 1);
      when(
        () => mockDataSource.fetchFiltered(any()),
      ).thenAnswer((_) async => [todo.copyWith(id: 1)]);

      await state.addTodo(todo);

      verify(() => mockDataSource.insert(todo)).called(1);
      verify(
        () => mockDataSource.fetchFiltered(const TodoFilters()),
      ).called(1);
      expect(state.todos, hasLength(1));
    });

    test('updateTodo updates and reloads', () async {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todo = Todo(
        id: 1,
        title: 'Updated task',
        tags: const ['home'],
        priority: TodoPriority.low,
        isCompleted: true,
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockDataSource.update(any())).thenAnswer((_) async => 1);
      when(
        () => mockDataSource.fetchFiltered(any()),
      ).thenAnswer((_) async => [todo]);

      await state.updateTodo(todo);

      verify(() => mockDataSource.update(todo)).called(1);
      verify(
        () => mockDataSource.fetchFiltered(const TodoFilters()),
      ).called(1);
    });

    test('toggleComplete updates completion status', () async {
      final now = DateTime(2026, 2, 6, 10, 30);
      final todo = Todo(
        id: 1,
        title: 'Task',
        tags: const ['work'],
        priority: TodoPriority.medium,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      );

      when(() => mockDataSource.update(any())).thenAnswer((_) async => 1);
      when(
        () => mockDataSource.fetchFiltered(any()),
      ).thenAnswer((_) async => [todo.copyWith(isCompleted: true)]);

      await state.toggleComplete(todo, true);

      final captured = verify(
        () => mockDataSource.update(captureAny()),
      ).captured;
      expect(captured, hasLength(1));
      final updatedTodo = captured.first as Todo;
      expect(updatedTodo.isCompleted, isTrue);
      expect(updatedTodo.id, todo.id);
    });

    test('deleteTodo removes and reloads', () async {
      when(() => mockDataSource.delete(1)).thenAnswer((_) async => 1);
      when(
        () => mockDataSource.fetchFiltered(any()),
      ).thenAnswer((_) async => []);

      await state.deleteTodo(1);

      verify(() => mockDataSource.delete(1)).called(1);
      verify(
        () => mockDataSource.fetchFiltered(const TodoFilters()),
      ).called(1);
      expect(state.todos, isEmpty);
    });

    test('setFilters applies filters and reloads', () async {
      final now = DateTime(2026, 2, 6, 10, 30);
      final filteredTodos = [
        Todo(
          id: 1,
          title: 'Work task',
          tags: const ['work'],
          priority: TodoPriority.high,
          isCompleted: true,
          createdAt: now,
          updatedAt: now,
        ),
      ];

      const filters = TodoFilters(
        isCompleted: true,
        priority: TodoPriority.high,
        tag: 'work',
        sortBy: TodoSortBy.priority,
        sortAscending: false,
      );

      when(
        () => mockDataSource.fetchFiltered(filters),
      ).thenAnswer((_) async => filteredTodos);

      await state.setFilters(filters);

      expect(state.todos, hasLength(1));
      expect(state.todos.first.title, 'Work task');
      verify(
        () => mockDataSource.fetchFiltered(filters),
      ).called(1);
    });

    test('clearFilters resets to defaults and reloads', () async {
      when(
        () => mockDataSource.fetchFiltered(const TodoFilters()),
      ).thenAnswer((_) async => []);

      await state.clearFilters();

      verify(
        () => mockDataSource.fetchFiltered(const TodoFilters()),
      ).called(1);
    });
  });
}
