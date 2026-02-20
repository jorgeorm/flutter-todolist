# Todo Demo

A feature-rich todo list application built with Flutter, demonstrating modern architecture patterns, multiple database backends, and comprehensive test coverage.

## Features

- ✅ **Full CRUD Operations**: Create, read, update, and delete todos
- 🏷️ **Rich Metadata**: Title, notes, tags, due dates, and priority levels (low/medium/high)
- 🔍 **Advanced Filtering**: Filter by completion status, priority, and tags
- 📊 **Flexible Sorting**: Sort by created date, due date, or priority
- 💾 **Multiple Backends**: Choose between SQLite and Isar (high-performance NoSQL)
- 🎨 **Native iOS Design**: Built with Cupertino widgets for authentic iOS look and feel
- 🖥️ **Cross-Platform**: Supports iOS, Android, macOS, Linux, and Windows
- 🧪 **Comprehensive Testing**: 40+ unit, integration, and widget tests
- 🏗️ **SOLID Architecture**: Clean separation of concerns with factory pattern and dependency injection

## Screenshots

_Coming soon_

## Quick Start

### Prerequisites

- Flutter SDK 3.10.8 or higher
- [FVM](https://fvm.app/) (Flutter Version Management) - optional but recommended
- Xcode (for iOS/macOS), Android Studio (for Android), or platform-specific tools

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd todo_demo
   ```

2. **Install dependencies**
   ```bash
   fvm flutter pub get
   ```

3. **Generate code** (for Freezed and Isar models)
   ```bash
   dart run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   ```bash
   # For iOS
   fvm flutter run -d ios
   
   # For macOS
   fvm flutter run -d macos
   
   # For Android
   fvm flutter run -d android
   ```

## Architecture

The app follows SOLID principles with a clean, layered architecture:

- **Model Layer**: Immutable data classes using Freezed
- **Data Layer**: Abstract `TodoDataSource` interface with multiple implementations
  - `TodoRepository`: SQLite implementation
  - `IsarTodoDataSource`: Isar NoSQL implementation
- **Service Layer**: Business logic for filtering and data operations
- **State Management**: `TodoState` using `ChangeNotifier`
- **UI Layer**: Cupertino widgets with modal sheets for forms

For detailed architecture documentation, see [lib/todo_manager/README.md](lib/todo_manager/README.md).

### Backend Flexibility

The app supports two database backends through a factory pattern:

| Backend | Use Case | Performance |
|---------|----------|-------------|
| **SQLite** (default) | General-purpose, SQL familiar | Good |
| **Isar** | Large datasets, high performance | Excellent |

**Switching backends** is as simple as changing one line in initialization. See [DATA_SOURCE_SWITCHING.md](lib/todo_manager/DATA_SOURCE_SWITCHING.md) for detailed instructions and performance comparisons.

## Testing

Run the complete test suite:

```bash
# All tests
fvm flutter test

# Todo manager tests only
fvm flutter test test/todo_manager/*_test.dart

# Run with coverage
fvm flutter test --coverage
```

**Test Coverage:**
- ✅ 40+ tests passing
- Unit tests with mocked dependencies (mocktail)
- Integration tests with in-memory databases
- Widget tests for UI components

## Platform Support

| Platform | Status | Notes |
|----------|--------|-------|
| iOS | ✅ Supported | Primary platform (Cupertino design) |
| Android | ✅ Supported | Cupertino widgets render on Android |
| macOS | ✅ Supported | Uses sqflite_common_ffi |
| Linux | ✅ Supported | Uses sqflite_common_ffi |
| Windows | ✅ Supported | Uses sqflite_common_ffi |
| Web | ⚠️ Not tested | May require backend adjustments |

## Technologies

### Core Dependencies
- **Flutter SDK** 3.10.8+
- **sqflite** ^2.4.2 - SQLite database for Flutter
- **sqflite_common_ffi** ^2.4.0+2 - SQLite for desktop platforms
- **isar** ^3.1.0+1 - High-performance NoSQL database
- **path_provider** ^2.1.5 - Platform-specific paths

### Code Generation
- **freezed** ^2.5.2 - Immutable data classes and unions
- **json_serializable** ^6.8.0 - JSON serialization
- **build_runner** ^2.4.13 - Code generation runner

### Testing
- **flutter_test** - Flutter testing framework
- **mocktail** ^1.0.4 - Mocking library

## Project Structure

```
lib/
├── main.dart                          # App entry point
├── shared/                            # Shared utilities
│   ├── milliseconds_converter.dart    # DateTime to MS converter
│   └── sqlite_boolean_converter.dart  # Boolean to int converter
└── todo_manager/                      # Todo feature module
    ├── models/                        # Data models
    │   └── todo_isar.dart            # Isar-specific model
    ├── services/                      # Business logic
    │   ├── isar_todo_data_source.dart
    │   ├── todo_data_source_factory.dart
    │   └── todo_filter_service.dart
    ├── sheets/                        # Modal bottom sheets
    │   ├── add_todo_sheet.dart
    │   └── filter_sheet.dart
    ├── todo.dart                      # Domain model
    ├── todo_sqlitedb.dart             # SQLite schema
    ├── todo_filters.dart              # Filter value object
    ├── todo_list_screen.dart          # Main UI
    ├── todo_manager_screen.dart       # Entry screen (SQLite)
    ├── todo_manager_screen_isar.dart  # Entry screen (Isar)
    ├── todo_sqlite_datasource.dart           # SQLite data source
    ├── todo_state.dart                # State management
    ├── README.md                      # Feature documentation
    └── DATA_SOURCE_SWITCHING.md           # Backend guide

test/
└── todo_manager/                      # Test suite
    ├── manual/                        # Manual/special tests
    │   └── isar_todo_data_source_integration_test.dart
    └── *_test.dart                    # Unit, integration, widget tests
```

## Development

### Running Code Generation

After modifying Freezed or Isar models:

```bash
# Watch mode (automatically regenerates on changes)
dart run build_runner watch --delete-conflicting-outputs

# One-time build
dart run build_runner build --delete-conflicting-outputs
```

### Debugging

The app includes detailed error handling and logging. For Isar-specific debugging:

```dart
// Enable Isar Inspector when opening database
final isar = await Isar.open(
  [TodoIsarSchema],
  directory: dir.path,
  inspector: true, // Allows connection from Isar Inspector
);
```

### Contributing

Contributions are welcome! Areas for expansion:
- [ ] Add recurring todos
- [ ] Implement categories/projects
- [ ] Add reminders/notifications
- [ ] Sync across devices
- [ ] Dark mode support
- [ ] Export/import functionality

## License

This project is available under the MIT License. See LICENSE file for details.

## Acknowledgments

Built with Flutter and following best practices in:
- Clean Architecture
- SOLID Principles
- Test-Driven Development (TDD)
- Factory Pattern for flexibility


## Next items to review

- [ - ] Add a new DB
- [ ] Review if we should apply solid principles to TodoFilterService so that queries can be built with concrete db engine syntax
- [ ] Dependency Injection (GetIt, Riverpod)
- [ ] Server Driven UIs
