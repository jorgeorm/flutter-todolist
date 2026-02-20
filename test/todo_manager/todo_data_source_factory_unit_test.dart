import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_demo/todo_manager/services/todo_data_source.dart';
import 'package:todo_demo/todo_manager/services/todo_data_source_factory.dart';
import 'package:todo_demo/todo_manager/services/todo_filter_service.dart';

class MockDatabase extends Mock implements Database {}

void main() {
  group('TodoDataSourceFactory', () {
    test('createSqlite creates TodoRepository with provided database', () {
      // Arrange
      final mockDatabase = MockDatabase();

      // Act
      final dataSource = TodoDataSourceFactory.createSqlite(
        database: mockDatabase,
      );

      // Assert
      expect(dataSource, isNotNull);
      expect(dataSource, isA<TodoDataSource>());
    });

    test('createSqliteWithFilterService creates TodoRepository with custom filter service',
        () {
      // Arrange
      final mockDatabase = MockDatabase();
      final filterService = const TodoFilterService();

      // Act
      final dataSource = TodoDataSourceFactory.createSqliteWithFilterService(
        database: mockDatabase,
        filterService: filterService,
      );

      // Assert
      expect(dataSource, isNotNull);
      expect(dataSource, isA<TodoDataSource>());
    });

    test('factory methods are accessible', () {
      // Assert that all factory methods exist and are callable
      expect(TodoDataSourceFactory.createSqlite, isNotNull);
      expect(TodoDataSourceFactory.createSqliteWithFilterService, isNotNull);
      expect(TodoDataSourceFactory.createIsar, isNotNull);
      expect(TodoDataSourceFactory.createIsarWithFilterService, isNotNull);
    });
  });
}

