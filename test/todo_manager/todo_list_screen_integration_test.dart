import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_demo/todo_manager/todo.dart';
import 'package:todo_demo/todo_manager/todo_database.dart';
import 'package:todo_demo/todo_manager/todo_list_screen.dart';
import 'package:todo_demo/todo_manager/todo_repository.dart';
import 'package:todo_demo/todo_manager/todo_state.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // Initialize sqflite FFI once for all tests
  setUpAll(() {
    sqfliteFfiInit();
  });

  testWidgets('TodoListScreen shows empty state when no todos',
      (WidgetTester tester) async {
    late TodoState state;
    
    await tester.runAsync(() async {
      final db = await TodoDatabase.openInMemory(databaseFactoryFfi);
      final repository = TodoRepository(database: db);
      addTearDown(() async => db.close());
      state = TodoState(repository: repository);
      await state.loadTodos();
    });

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
    late TodoState state;
    
    await tester.runAsync(() async {
      final db = await TodoDatabase.openInMemory(databaseFactoryFfi);
      final repository = TodoRepository(database: db);
      addTearDown(() async => db.close());
      state = TodoState(repository: repository);

      final now = DateTime(2026, 2, 6, 10, 30);
      await state.addTodo(
        Todo(
          title: 'Buy milk',
          tags: const ['shopping'],
          priority: TodoPriority.high,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    expect(find.text('Buy milk'), findsOneWidget);
    expect(find.byType(CupertinoListTile), findsWidgets);

  });

  testWidgets('TodoListScreen has add button', (WidgetTester tester) async {
    late TodoState state;
    
    await tester.runAsync(() async {
      final db = await TodoDatabase.openInMemory(databaseFactoryFfi);
      final repository = TodoRepository(database: db);
      addTearDown(() async => db.close());
      state = TodoState(repository: repository);
      await state.loadTodos();
    });

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    expect(find.byIcon(CupertinoIcons.add), findsWidgets);

  });

  testWidgets('toggle todo completion', (WidgetTester tester) async {
    late TodoState state;
    
    await tester.runAsync(() async {
      final db = await TodoDatabase.openInMemory(databaseFactoryFfi);
      final repository = TodoRepository(database: db);
      addTearDown(() async => db.close());
      state = TodoState(repository: repository);

      final now = DateTime(2026, 2, 6, 10, 30);
      await state.addTodo(
        Todo(
          title: 'Write email',
          tags: const ['work'],
          priority: TodoPriority.medium,
          isCompleted: false,
          createdAt: now,
          updatedAt: now,
        ),
      );
    });

    await tester.pumpWidget(
      CupertinoApp(
        home: TodoListScreen(state: state),
      ),
    );
    await tester.pump();

    final checkbox = find.byType(CupertinoCheckbox);
    expect(checkbox, findsOneWidget);

    // Toggle completion through state (simulating user interaction)
    await tester.runAsync(() async {
      await state.toggleComplete(state.todos.first, true);
    });
    await tester.pump();

    expect(state.todos.first.isCompleted, isTrue);

  });
}
