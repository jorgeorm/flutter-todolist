# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] - 2026-02-20

### Added

- **Multi-Database Support**: New Isar backend as high-performance alternative to SQLite with identical feature parity
  - `TodoDataSource` abstract interface for swappable data backend implementations
  - `TodoDataSourceFactory` factory pattern for creating SQLite or Isar data sources
  - `IsarTodoDataSource` implementation for high-performance NoSQL operations
  - `TodoManagerScreenIsar` example implementation showcasing Isar backend
  - Backend switching guide in `DATA_SOURCE_SWITCHING.md` with performance comparison
- **Service Layer Architecture**: Improved code organization and SOLID principles compliance
  - `TodoFilterService` extracted for reusable filter/sort logic
  - `TodoFilters` immutable model consolidating all filter criteria
  - New folder structure: `models/`, `services/`, `sheets/` for better separation of concerns
- **Extracted UI Components**: Modular sheet components
  - `AddTodoSheet` for todo creation
  - `FilterSheet` for filtering and sorting todos
- **Comprehensive Test Coverage**: Integration and unit tests for both SQLite and Isar backends
  - Isar data source integration tests (tagged `@Tags(['isar'])`)
  - SQLite data source integration tests
  - Filter service and TodoFilters unit tests
  - Data source factory unit tests
  - All existing tests updated to use new abstract interface

### Changed

- **Reorganized folder structure** for improved code organization and maintainability
  - Models moved to `lib/todo_manager/models/` (Todo, TodoFilters, TodoIsar)
  - Data sources and services moved to `lib/todo_manager/services/`
  - UI sheets moved to `lib/todo_manager/sheets/`
- **Updated TodoState API**: `setFilters()` now accepts `TodoFilters` object instead of individual parameters
- **Renamed classes** for clarity: `TodoDatabase` → `TodoSqliteDb`
- **Updated all imports** throughout codebase to reflect new folder structure
- All tests updated to use new `TodoDataSource` interface and `TodoFilters` object

### Dependencies

- Added: `isar: ^3.1.0+1`, `isar_flutter_libs: ^3.1.0+1` (runtime)
- Added (dev): `isar_generator: ^3.1.0+1` for Isar code generation
- Platform support: Registered Isar plugin on Linux, macOS, Windows

### Migration Notes

- **Import Changes**: Update imports to new folder structure
  - Old: `import 'todo_manager/todo.dart'`
  - New: `import 'todo_manager/models/todo.dart'`
- **API Migration**: Filter calls updated to use `TodoFilters` object
  - Old: `state.setFilters(isCompleted: true, priority: null, ...)`
  - New: `state.setFilters(const TodoFilters(isCompleted: true, ...))`
- **Backward Compatibility**: Deprecated factory methods provided for gradual migration
- See `DATA_SOURCE_SWITCHING.md` for backend selection and usage guide

## [0.1.0] - 2026-02-19

### Added

- **Todo Management Core**: Full CRUD operations for todos with persistence via SQLite
- **Data Model**: Comprehensive `Todo` model with fields for title, notes, tags, due date, priority levels (low/medium/high), completion status, and creation/update timestamps
- **SQLite Persistence**: Desktop-optimized database layer with schema management using sqflite for mobile and sqflite_common_ffi for desktop platforms (macOS, Linux, Windows)
- **Todo List Screen**: UI for displaying, adding, and managing todos with Cupertino (iOS-style) design
- **Filtering & Sorting**: Advanced filtering by completion status, priority level, and tags with support for multiple sort options (by created date, due date, or priority)
- **State Management**: `TodoState` ChangeNotifier for reactive UI updates and filter state management
- **Multi-tag Support**: Todos can have multiple tags with JSON serialization for database storage
- **Serialization**: JSON serialization/deserialization for todos with custom converters for SQLite boolean and millisecond timestamp handling
- **Desktop Support**: Full support for macOS, Linux, and Windows with sqflite_common_ffi initialization
- **Freezed Models**: Immutable data classes generated with freezed_annotation for type safety and easier comparison
- **Testing Infrastructure**: Unit, integration, and widget test setup with mocktail for mocking

### Technical Details

- **Framework**: Flutter 3.10.8+
- **Architecture**: Repository pattern with state management via ChangeNotifier
- **Design System**: Cupertino widgets for iOS-style UI consistency
- **Code Generation**: Build runner with freezed and json_serializable for code generation
- **Testing**: Flutter test framework with mocktail for dependency mocking

[0.2.0]: https://github.com/user/todo_demo/releases/tag/v0.2.0
[0.1.0]: https://github.com/user/todo_demo/releases/tag/v0.1.0
