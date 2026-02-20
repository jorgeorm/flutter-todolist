import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'models/todo_isar.dart';
import 'services/todo_data_source_factory.dart';
import 'todo_list_screen.dart';
import 'todo_state.dart';

/// Example of TodoManagerScreen using Isar backend instead of SQLite
///
/// To use this version:
/// 1. Replace the import in main.dart:
///    - Change: import 'todo_manager/todo_manager_screen.dart';
///    - To: import 'todo_manager/todo_manager_screen_isar.dart';
///
/// 2. Update main.dart to use TodoManagerScreenIsar:
///    home: const TodoManagerScreenIsar(),
///
/// Note: Remove the sqflite initialization code from main.dart if using Isar exclusively
class TodoManagerScreenIsar extends StatefulWidget {
  const TodoManagerScreenIsar({super.key});

  @override
  State<TodoManagerScreenIsar> createState() => _TodoManagerScreenIsarState();
}

class _TodoManagerScreenIsarState extends State<TodoManagerScreenIsar> {
  late Future<TodoState> _stateInit;
  TodoState? _state;

  @override
  void initState() {
    super.initState();
    _stateInit = _initializeState();
  }

  Future<TodoState> _initializeState() async {
    // Get app directory for production use
    final Directory appDir;
    if (Platform.isIOS || Platform.isAndroid) {
      appDir = await getApplicationDocumentsDirectory();
    } else {
      // For desktop platforms, use application support directory
      appDir = await getApplicationSupportDirectory();
    }

    // Open Isar database
    final isar = await Isar.open(
      [TodoIsarSchema],
      directory: appDir.path,
      name: 'todo_isar_db',
      // Set inspector: true for debugging (allows Isar Inspector connection)
      inspector: false,
    );

    // Create data source using factory
    final dataSource = TodoDataSourceFactory.createIsar(isar: isar);

    // Initialize state and load todos
    final state = TodoState(dataSource: dataSource);
    await state.loadTodos();

    _state = state;
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
    // Close Isar database when widget is disposed
    _state?.dataSource.close();
    super.dispose();
  }
}
