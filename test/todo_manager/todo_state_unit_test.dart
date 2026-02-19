import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_demo/todo_manager/todo.dart';
import 'package:todo_demo/todo_manager/todo_repository.dart';
import 'package:todo_demo/todo_manager/todo_state.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;
  late TodoState state;

  setUpAll(() {
    // Register fallback values for any types used in matchers
    registerFallbackValue(
      Todo(title: '', createdAt: DateTime.now(), updatedAt: DateTime.now()),
    );
    registerFallbackValue(TodoSortBy.createdAt);
    registerFallbackValue(TodoPriority.medium);
  });

  setUp(() {
    mockRepository = MockTodoRepository();
    state = TodoState(repository: mockRepository);
  });

  group('TodoState with mocks', () {
    test('loadTodos fetches from repository and notifies listeners', () async {
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
        () => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        ),
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
        () => mockRepository.fetchFiltered(
          isCompleted: null,
          priority: null,
          tag: null,
          sortBy: TodoSortBy.createdAt,
          sortAscending: true,
        ),
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

      when(() => mockRepository.insert(any())).thenAnswer((_) async => 1);
      when(
        () => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        ),
      ).thenAnswer((_) async => [todo.copyWith(id: 1)]);

      await state.addTodo(todo);

      verify(() => mockRepository.insert(todo)).called(1);
      verify(
        () => mockRepository.fetchFiltered(
          isCompleted: null,
          priority: null,
          tag: null,
          sortBy: TodoSortBy.createdAt,
          sortAscending: true,
        ),
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

      when(() => mockRepository.update(any())).thenAnswer((_) async => 1);
      when(
        () => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        ),
      ).thenAnswer((_) async => [todo]);

      await state.updateTodo(todo);

      verify(() => mockRepository.update(todo)).called(1);
      verify(
        () => mockRepository.fetchFiltered(
          isCompleted: null,
          priority: null,
          tag: null,
          sortBy: TodoSortBy.createdAt,
          sortAscending: true,
        ),
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

      when(() => mockRepository.update(any())).thenAnswer((_) async => 1);
      when(
        () => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        ),
      ).thenAnswer((_) async => [todo.copyWith(isCompleted: true)]);

      await state.toggleComplete(todo, true);

      final captured = verify(
        () => mockRepository.update(captureAny()),
      ).captured;
      expect(captured, hasLength(1));
      final updatedTodo = captured.first as Todo;
      expect(updatedTodo.isCompleted, isTrue);
      expect(updatedTodo.id, todo.id);
    });

    test('deleteTodo removes and reloads', () async {
      when(() => mockRepository.delete(1)).thenAnswer((_) async => 1);
      when(
        () => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        ),
      ).thenAnswer((_) async => []);

      await state.deleteTodo(1);

      verify(() => mockRepository.delete(1)).called(1);
      verify(
        () => mockRepository.fetchFiltered(
          isCompleted: null,
          priority: null,
          tag: null,
          sortBy: TodoSortBy.createdAt,
          sortAscending: true,
        ),
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

      when(
        () => mockRepository.fetchFiltered(
          isCompleted: true,
          priority: TodoPriority.high,
          tag: 'work',
          sortBy: TodoSortBy.priority,
          sortAscending: false,
        ),
      ).thenAnswer((_) async => filteredTodos);

      await state.setFilters(
        isCompleted: true,
        priority: TodoPriority.high,
        tag: 'work',
        sortBy: TodoSortBy.priority,
        sortAscending: false,
      );

      expect(state.todos, hasLength(1));
      expect(state.todos.first.title, 'Work task');
      verify(
        () => mockRepository.fetchFiltered(
          isCompleted: true,
          priority: TodoPriority.high,
          tag: 'work',
          sortBy: TodoSortBy.priority,
          sortAscending: false,
        ),
      ).called(1);
    });

    test('clearFilters resets to defaults and reloads', () async {
      when(
        () => mockRepository.fetchFiltered(
          isCompleted: null,
          priority: null,
          tag: null,
          sortBy: TodoSortBy.createdAt,
          sortAscending: true,
        ),
      ).thenAnswer((_) async => []);

      await state.clearFilters();

      verify(
        () => mockRepository.fetchFiltered(
          isCompleted: null,
          priority: null,
          tag: null,
          sortBy: TodoSortBy.createdAt,
          sortAscending: true,
        ),
      ).called(1);
    });
  });
}
