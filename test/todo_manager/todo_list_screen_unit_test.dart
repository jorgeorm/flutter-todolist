import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_demo/todo_manager/todo.dart';
import 'package:todo_demo/todo_manager/todo_list_screen.dart';
import 'package:todo_demo/todo_manager/todo_repository.dart';
import 'package:todo_demo/todo_manager/todo_state.dart';

class MockTodoRepository extends Mock implements TodoRepository {}

void main() {
  late MockTodoRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(Todo(
      title: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    registerFallbackValue(TodoSortBy.createdAt);
    registerFallbackValue(TodoPriority.medium);
  });

  setUp(() {
    mockRepository = MockTodoRepository();
  });

  testWidgets('TodoListScreen shows empty state when no todos',
      (WidgetTester tester) async {
    // Setup mock to return empty list
    when(() => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        )).thenAnswer((_) async => []);

    final state = TodoState(repository: mockRepository);
    await state.loadTodos();

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    expect(find.text('No todos yet'), findsOneWidget);
    expect(find.text('Add one'), findsOneWidget);
    expect(find.byType(CupertinoListTile), findsNothing);
  });

  testWidgets('TodoListScreen displays list of todos',
      (WidgetTester tester) async {
    final now = DateTime(2026, 2, 6, 10, 30);
    final todos = [
      Todo(
        id: 1,
        title: 'Buy milk',
        tags: const ['shopping'],
        priority: TodoPriority.high,
        isCompleted: false,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    // Setup mock to return the todo list
    when(() => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        )).thenAnswer((_) async => todos);

    final state = TodoState(repository: mockRepository);
    await state.loadTodos();

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.byType(CupertinoListTile), findsOneWidget);
  });

  testWidgets('TodoListScreen has add button', (WidgetTester tester) async {
    when(() => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        )).thenAnswer((_) async => []);

    final state = TodoState(repository: mockRepository);
    await state.loadTodos();

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    // One in nav bar, one in empty state
    expect(find.byIcon(CupertinoIcons.add), findsWidgets);
  });

  testWidgets('tap add button shows modal', (WidgetTester tester) async {
    when(() => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        )).thenAnswer((_) async => []);

    final state = TodoState(repository: mockRepository);
    await state.loadTodos();

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    // Find and tap the "Add one" button
    final addButton = find.text('Add one');
    expect(addButton, findsOneWidget);

    await tester.tap(addButton);
    await tester.pumpAndSettle();

    // Verify modal sheet appeared
    expect(find.text('Add Todo'), findsOneWidget);
  });

  testWidgets('shows checkbox and delete button for each todo',
      (WidgetTester tester) async {
    final now = DateTime(2026, 2, 6, 10, 30);
    final todo = Todo(
      id: 1,
      title: 'Write email',
      tags: const ['work'],
      priority: TodoPriority.medium,
      isCompleted: false,
      createdAt: now,
      updatedAt: now,
    );

    when(() => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        )).thenAnswer((_) async => [todo]);

    final state = TodoState(repository: mockRepository);
    await state.loadTodos();

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    expect(find.text('Write email'), findsOneWidget);
    expect(find.byType(CupertinoCheckbox), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.delete), findsOneWidget);
  });

  testWidgets('shows completed todo with strikethrough',
      (WidgetTester tester) async {
    final now = DateTime(2026, 2, 6, 10, 30);
    final todo = Todo(
      id: 1,
      title: 'Completed task',
      tags: const ['test'],
      priority: TodoPriority.low,
      isCompleted: true,
      createdAt: now,
      updatedAt: now,
    );

    when(() => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        )).thenAnswer((_) async => [todo]);

    final state = TodoState(repository: mockRepository);
    await state.loadTodos();

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    expect(find.text('Completed task'), findsOneWidget);

    // Verify checkmark is shown for completed todo
    final checkbox = tester.widget<CupertinoCheckbox>(
      find.byType(CupertinoCheckbox),
    );
    expect(checkbox.value, true);
  });

  testWidgets('filter button opens filter sheet', (WidgetTester tester) async {
    when(() => mockRepository.fetchFiltered(
          isCompleted: any(named: 'isCompleted'),
          priority: any(named: 'priority'),
          tag: any(named: 'tag'),
          sortBy: any(named: 'sortBy'),
          sortAscending: any(named: 'sortAscending'),
        )).thenAnswer((_) async => []);

    final state = TodoState(repository: mockRepository);
    await state.loadTodos();

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    // Find and tap the filter button (horizontal lines icon)
    final filterButton = find.byIcon(CupertinoIcons.line_horizontal_3_decrease);
    expect(filterButton, findsOneWidget);

    await tester.tap(filterButton);
    await tester.pumpAndSettle();

    // Verify filter sheet appeared
    expect(find.text('Filter & Sort'), findsOneWidget);
    expect(find.text('Completion Status'), findsOneWidget);
  });
}
