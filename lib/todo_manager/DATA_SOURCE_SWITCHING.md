# Backend Switching Guide

This todo app supports multiple database backends through the `TodoDataSource` interface and `TodoDataSourceFactory`.

## Available Backends

### 1. SQLite (Default)
- **Use case**: General-purpose, mature SQL database
- **Performance**: Good for most use cases
- **Dependencies**: `sqflite`, `sqflite_common_ffi`

### 2. Isar (Alternative)
- **Use case**: High-performance NoSQL database
- **Performance**: Optimized for Flutter, faster for large datasets
- **Dependencies**: `isar`, `isar_flutter_libs`

## How to Switch Backends

### Using SQLite (Current Default)

```dart
// In todo_manager_screen.dart
Future<TodoState> _initializeState() async {
  final db = await TodoSqliteDb.open();
  final dataSource = TodoDataSourceFactory.createSqlite(database: db);
  final state = TodoState(dataSource: dataSource);
  await state.loadTodos();
  return state;
}
```

### Using Isar

```dart
// In todo_manager_screen.dart
import 'package:isar/isar.dart';
import 'models/todo_isar.dart';

Future<TodoState> _initializeState() async {
  // Initialize Isar for production use
  final dir = await getApplicationDocumentsDirectory();
  
  final isar = await Isar.open(
    [TodoIsarSchema],
    directory: dir.path,
  );
  
  final dataSource = TodoDataSourceFactory.createIsar(isar: isar);
  final state = TodoState(dataSource: dataSource);
  await state.loadTodos();
  return state;
}

// Don't forget to close Isar when the widget is disposed
@override
void dispose() {
  _state?.dataSource.close();
  super.dispose();
}
```

## Backend Comparison

| Feature | SQLite | Isar |
|---------|--------|------|
| Query language | SQL | QueryBuilder API |
| Indexes | Manual SQL indexes | Annotation-based (@Index) |
| Relationships | Foreign keys | Links & backlinks |
| Schema changes | Migrations required | Auto-migration |
| Multi-threading | Limited | Built-in |
| Performance (reads) | Good | Excellent |
| Performance (writes) | Good | Excellent |
| Package size | Smaller | Larger (native libs) |

## Implementation Notes

### Isar Limitations
1. **Complex filters with indexes**: Isar can only use one index per query. When filtering by multiple indexed fields (e.g., `isCompleted` + `priority`), the implementation fetches using one index and filters the rest in-memory.

2. **List field filtering**: Filtering by list fields (like `tags`) is done in-memory because Isar doesn't support compound index queries on list fields.

3. **Sorting**: After applying filters, sorting is done in-memory for consistency.

### When to Choose Each Backend

**Choose SQLite when:**
- You need SQL querying capabilities
- Your app is simple and doesn't require high performance
- You want a smaller package size
- You already know SQL

**Choose Isar when:**
- You need maximum performance for reads/writes
- You're working with large datasets (1000+ items)
- You want automatic schema migration
- You prefer a type-safe QueryBuilder API
- Multi-threading is important

## Testing

Both backends are tested through the same `TodoDataSource` interface:

```bash
# Test SQLite backend (and all other tests)
flutter test test/todo_manager/*_test.dart

# Test Isar backend (requires Flutter test environment)
# Downloads Isar core on first run; requires network access
flutter test --tags isar
```

## Architecture Benefits

The factory pattern allows switching backends without changing:
- `TodoState` business logic
- `TodoListScreen` UI
- `TodoManagerScreen` state management (except initialization)
- Test mocks

All backend implementations must satisfy the `TodoDataSource` interface contract.
