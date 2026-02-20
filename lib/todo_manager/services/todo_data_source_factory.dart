import 'package:isar/isar.dart';
import 'package:sqflite/sqflite.dart';

import 'isar_todo_data_source.dart';
import 'todo_data_source.dart';
import 'todo_filter_service.dart';
import 'sqlite_todo_datasource.dart';

/// Factory for creating TodoDataSource implementations.
///
/// This factory abstracts away the concrete implementation details,
/// allowing for easy swapping of data sources (e.g., SQLite, Isar, Firestore, API).
abstract class TodoDataSourceFactory {
  // SQLite backends

  /// Creates a production SQLite SqliteTodoDatasource with default TodoFilterService.
  ///
  /// Use this for SQLite-based storage in production.
  static TodoDataSource createSqlite({
    required Database database,
  }) {
    return SqliteTodoDatasource(
      database: database,
    );
  }

  /// Creates a SQLite SqliteTodoDatasource with a custom TodoFilterService.
  ///
  /// Use this for SQLite-based storage with specialized filter logic.
  static TodoDataSource createSqliteWithFilterService({
    required Database database,
    required TodoFilterService filterService,
  }) {
    return SqliteTodoDatasource(
      database: database,
      filterService: filterService,
    );
  }

  // Isar backends

  /// Creates an Isar-based TodoDataSource with default TodoFilterService.
  ///
  /// Use this for Isar-based storage (high-performance NoSQL).
  static TodoDataSource createIsar({
    required Isar isar,
  }) {
    return IsarTodoDataSource(
      isar: isar,
    );
  }

  /// Creates an Isar-based TodoDataSource with a custom TodoFilterService.
  ///
  /// Use this for Isar-based storage with specialized filter logic.
  static TodoDataSource createIsarWithFilterService({
    required Isar isar,
    required TodoFilterService filterService,
  }) {
    return IsarTodoDataSource(
      isar: isar,
      filterService: filterService,
    );
  }

  // Backward compatibility - defaults to SQLite

  /// Creates a production SqliteTodoDatasource with default TodoFilterService.
  ///
  /// Deprecated: Use [createSqlite] instead.
  /// This method maintains backward compatibility.
  @Deprecated('Use createSqlite() instead')
  static TodoDataSource create({
    required Database database,
  }) {
    return createSqlite(database: database);
  }

  /// Creates a SqliteTodoDatasource with a custom TodoFilterService.
  ///
  /// Deprecated: Use [createSqliteWithFilterService] instead.
  /// This method maintains backward compatibility.
  @Deprecated('Use createSqliteWithFilterService() instead')
  static TodoDataSource createWithFilterService({
    required Database database,
    required TodoFilterService filterService,
  }) {
    return createSqliteWithFilterService(
      database: database,
      filterService: filterService,
    );
  }
}
