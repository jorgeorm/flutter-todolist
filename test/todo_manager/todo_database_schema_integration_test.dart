import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:todo_demo/todo_manager/models/todo.dart';
import 'package:todo_demo/todo_manager/todo_sqlitedb.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();

  test('opens database and creates todos table', () async {
    final db = await TodoSqliteDb.openInMemory(databaseFactoryFfi);

    final columns = await db.rawQuery('PRAGMA table_info(todos)');
    final columnNames = columns
        .map((column) => column['name'])
        .whereType<String>()
        .toList();

    expect(
      columnNames,
      containsAll(
        <String>[
          TodoFields.id,
          TodoFields.title,
          TodoFields.notes,
          TodoFields.tags,
          TodoFields.dueDate,
          TodoFields.priority,
          TodoFields.isCompleted,
          TodoFields.createdAt,
          TodoFields.updatedAt,
        ],
      ),
    );

    await db.close();
  });
}
