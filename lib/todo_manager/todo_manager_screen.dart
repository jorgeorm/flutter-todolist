import 'package:flutter/cupertino.dart';

import 'todo_database.dart';
import 'todo_list_screen.dart';
import 'todo_repository.dart';
import 'todo_state.dart';

class TodoManagerScreen extends StatefulWidget {
  const TodoManagerScreen({super.key});

  @override
  State<TodoManagerScreen> createState() => _TodoManagerScreenState();
}

class _TodoManagerScreenState extends State<TodoManagerScreen> {
  late Future<TodoState> _stateInit;

  @override
  void initState() {
    super.initState();
    _stateInit = _initializeState();
  }

  Future<TodoState> _initializeState() async {
    final db = await TodoDatabase.open();
    final repository = TodoRepository(database: db);
    final state = TodoState(repository: repository);
    await state.loadTodos();
    return state;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<TodoState>(
      future: _stateInit,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return CupertinoPageScaffold(
            navigationBar: const CupertinoNavigationBar(middle: Text('Error')),
            child: Center(
              child: Text('Error: ${snapshot.error}'),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(middle: Text('Loading')),
            child: Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        }

        return TodoListScreen(state: snapshot.data!);
      },
    );
  }

  @override
  void dispose() {
    _stateInit.then((state) => state.dispose());
    super.dispose();
  }
}
