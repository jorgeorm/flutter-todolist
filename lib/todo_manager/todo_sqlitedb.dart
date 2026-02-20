import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'models/todo.dart';

class TodoSqliteDb {
  static const String _databaseName = 'todo_manager.db';
  static const int _databaseVersion = 1;

  static Future<Database> open({DatabaseFactory? dbFactory}) async {
    final factory = dbFactory ?? databaseFactory;
    final directory = await getApplicationDocumentsDirectory();
    final dbPath = path.join(directory.path, _databaseName);

    return await factory.openDatabase(
      dbPath,
      options: OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: _createSchema,
      ),
    );
  }

  static Future<Database> openInMemory(DatabaseFactory databaseFactory) {
    return databaseFactory.openDatabase(
      inMemoryDatabasePath,
      options: OpenDatabaseOptions(
        version: _databaseVersion,
        onCreate: _createSchema,
      ),
    );
  }

  static Future<void> _createSchema(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        ${TodoFields.id} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${TodoFields.title} TEXT NOT NULL,
        ${TodoFields.notes} TEXT,
        ${TodoFields.tags} TEXT NOT NULL,
        ${TodoFields.dueDate} INTEGER,
        ${TodoFields.priority} INTEGER NOT NULL,
        ${TodoFields.isCompleted} INTEGER NOT NULL,
        ${TodoFields.createdAt} INTEGER NOT NULL,
        ${TodoFields.updatedAt} INTEGER NOT NULL
      )
    ''');
  }
}
