# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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

[0.1.0]: https://github.com/user/todo_demo/releases/tag/v0.1.0
