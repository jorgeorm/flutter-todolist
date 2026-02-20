import 'package:flutter/cupertino.dart';

import 'services/todo_data_source.dart';
import 'sheets/add_todo_sheet.dart';
import 'sheets/filter_sheet.dart';
import 'models/todo.dart';
import 'models/todo_filters.dart';
import 'todo_state.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({required this.state, super.key});

  final TodoState state;

  @override
  State<TodoListScreen> createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    widget.state.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.state.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Todos'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showFilterSheet,
          child: const Icon(CupertinoIcons.line_horizontal_3_decrease),
        ),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: _showAddTodoSheet,
          child: const Icon(CupertinoIcons.add),
        ),
      ),
      child: SafeArea(
        child: widget.state.todos.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No todos yet',
                      style: TextStyle(fontSize: 16, color: CupertinoColors.secondaryLabel),
                    ),
                    const SizedBox(height: 8),
                    CupertinoButton(
                      onPressed: _showAddTodoSheet,
                      child: const Text('Add one'),
                    ),
                  ],
                ),
              )
            : _buildTodoList(),
      ),
    );
  }

  Widget _buildTodoList() {
    return CupertinoListSection.insetGrouped(
      children: widget.state.todos.map((todo) {
        return _TodoListItem(
          todo: todo,
          onToggle: (isCompleted) {
            widget.state.toggleComplete(todo, isCompleted);
          },
          onDelete: () {
            widget.state.deleteTodo(todo.id!);
          },
        );
      }).toList(),
    );
  }

  void _showAddTodoSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => AddTodoSheet(
        onSave: (todo) {
          widget.state.addTodo(todo);
          Navigator.pop(context);
        },
      ),
    );
  }

  void _showFilterSheet() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => FilterSheet(
        state: widget.state,
        onApply: (filters) {
          widget.state.setFilters(
            TodoFilters(
              isCompleted: filters['isCompleted'],
              priority: filters['priority'],
              tag: filters['tag'],
              sortBy: filters['sortBy'] ?? TodoSortBy.createdAt,
              sortAscending: filters['sortAscending'] ?? true,
            ),
          );
          Navigator.pop(context);
        },
        onClear: () {
          widget.state.clearFilters();
          Navigator.pop(context);
        },
      ),
    );
  }
}

class _TodoListItem extends StatelessWidget {
  const _TodoListItem({
    required this.todo,
    required this.onToggle,
    required this.onDelete,
  });

  final Todo todo;
  final Function(bool) onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return CupertinoListTile(
      title: Text(
        todo.title,
        style: TextStyle(
          decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
        ),
      ),
      subtitle: todo.notes != null
          ? Text(
              todo.notes!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CupertinoCheckbox(
            value: todo.isCompleted,
            onChanged: (value) => onToggle(value ?? false),
          ),
          CupertinoButton(
            padding: const EdgeInsets.all(8),
            onPressed: onDelete,
            child: const Icon(CupertinoIcons.delete),
          ),
        ],
      ),
    );
  }
}
