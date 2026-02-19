# Todo Manager

Feature module for a simple Todo list manager built with Cupertino widgets and SQLite persistence.

## Overview
- Single list of todos (no projects).
- Fields: title, notes (optional), tags (multiple), due date (optional), priority (low/medium/high), completed, created/updated timestamps.
- Core flows: list, add, complete/uncomplete, delete.
- Filters: completion, priority, tag; sort by created date, due date, or priority.
- Persistence: SQLite via sqflite (desktop uses sqflite_common_ffi).

## Architecture
- Model: `Todo` with serialization helpers.
- Data: `TodoDatabase` creates the schema and opens SQLite databases.
- Repository: `TodoRepository` handles CRUD, filtering, and sorting.
- State: `TodoState` (ChangeNotifier) owns filters and the current list.
- UI: `TodoListScreen` for list + add/filter sheets, `TodoManagerScreen` as entry.

## Data Model
- `TodoPriority`: low, medium, high.
- `Todo` fields:
  - id (nullable until persisted)
  - title (required)
  - notes (optional)
  - tags (list of strings)
  - dueDate (optional)
  - priority
  - isCompleted
  - createdAt, updatedAt

## Persistence
- Schema is created in `TodoDatabase`.
- Tags are stored as a JSON string in a text column.
- Sorting supports null-safe due dates (nulls last for ascending).

## UI Behavior
- Empty state shows "No todos yet" with a CTA button.
- Add todo uses a modal popup form.
- Filter/sort uses a modal sheet with segmented controls.

## Testing
The module has unit, integration, and widget tests.

Run all Todo Manager tests:

```bash
fvm flutter test test/todo_manager
```

Common groups:
- Unit (mocked): `todo_state_mock_test.dart`
- Integration: `todo_model_test.dart`, `todo_database_schema_test.dart`,
  `todo_repository_test.dart`, `todo_state_test.dart`
- Widget: `todo_list_screen_mock_test.dart`, `todo_list_screen_test.dart`

Note: integration-style widget tests use `tester.runAsync` to allow real
SQLite I/O to complete outside the FakeAsync zone.

## Desktop Support
For macOS/Linux/Windows, the app initializes `sqflite_common_ffi` at startup
and uses the FFI database factory for SQLite access.
