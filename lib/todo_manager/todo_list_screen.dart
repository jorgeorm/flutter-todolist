import 'package:flutter/cupertino.dart';

import 'todo.dart';
import 'todo_repository.dart';
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
      builder: (context) => _AddTodoSheet(
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
      builder: (context) => _FilterSheet(
        state: widget.state,
        onApply: (filters) {
          widget.state.setFilters(
            isCompleted: filters['isCompleted'],
            priority: filters['priority'],
            tag: filters['tag'],
            sortBy: filters['sortBy'] ?? TodoSortBy.createdAt,
            sortAscending: filters['sortAscending'] ?? true,
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

class _AddTodoSheet extends StatefulWidget {
  const _AddTodoSheet({required this.onSave});

  final Function(Todo) onSave;

  @override
  State<_AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<_AddTodoSheet> {
  late TextEditingController _titleController;
  late TextEditingController _notesController;
  final TodoPriority _priority = TodoPriority.medium;
  DateTime? _dueDate;
  final List<String> _tags = [];

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _notesController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_titleController.text.isEmpty) {
      return;
    }
    final todo = Todo(
      title: _titleController.text,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      tags: _tags,
      priority: _priority,
      dueDate: _dueDate,
      isCompleted: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    widget.onSave(todo);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CupertinoColors.systemBackground,
      child: SafeArea(
        bottom: true,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Add Todo',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              CupertinoTextField(
                controller: _titleController,
                placeholder: 'Title',
              ),
              const SizedBox(height: 12),
              CupertinoTextField(
                controller: _notesController,
                placeholder: 'Notes (optional)',
                maxLines: 2,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CupertinoButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  CupertinoButton.filled(
                    onPressed: _handleSave,
                    child: const Text('Save'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({
    required this.state,
    required this.onApply,
    required this.onClear,
  });

  final TodoState state;
  final Function(Map<String, dynamic>) onApply;
  final VoidCallback onClear;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  _CompletionFilter _completionFilter = _CompletionFilter.all;
  _PriorityFilter _priorityFilter = _PriorityFilter.all;
  String? _filterTag;
  TodoSortBy _sortBy = TodoSortBy.createdAt;
  bool _sortAscending = true;
  Set<String> _allTags = {};

  @override
  void initState() {
    super.initState();
    _collectAllTags();
  }

  void _collectAllTags() {
    final tags = <String>{};
    for (final todo in widget.state.todos) {
      tags.addAll(todo.tags);
    }
    _allTags = tags;
  }

  void _handleApply() {
    widget.onApply({
      'isCompleted': _completionFilter == _CompletionFilter.all
          ? null
          : _completionFilter == _CompletionFilter.completed,
      'priority': _priorityFilter == _PriorityFilter.all
          ? null
          : _priorityFilter == _PriorityFilter.low
              ? TodoPriority.low
              : _priorityFilter == _PriorityFilter.medium
                  ? TodoPriority.medium
                  : TodoPriority.high,
      'tag': _filterTag,
      'sortBy': _sortBy,
      'sortAscending': _sortAscending,
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: const Text('Filter & Sort'),
        trailing: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: widget.onClear,
          child: const Text('Clear'),
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildSection(
              'Completion Status',
              CupertinoSegmentedControl<_CompletionFilter>(
                groupValue: _completionFilter,
                children: const {
                  _CompletionFilter.all: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('All'),
                  ),
                  _CompletionFilter.active: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Active'),
                  ),
                  _CompletionFilter.completed: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Done'),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _completionFilter = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            _buildSection(
              'Priority',
              CupertinoSegmentedControl<_PriorityFilter>(
                groupValue: _priorityFilter,
                children: const {
                  _PriorityFilter.all: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('All'),
                  ),
                  _PriorityFilter.low: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Low'),
                  ),
                  _PriorityFilter.medium: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Med'),
                  ),
                  _PriorityFilter.high: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('High'),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _priorityFilter = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24),
            if (_allTags.isNotEmpty) ...[
              _buildSection(
                'Tag',
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _buildTagChip('All', _filterTag == null),
                    ..._allTags.map((tag) => _buildTagChip(tag, _filterTag == tag)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
            ],
            _buildSection(
              'Sort By',
              CupertinoSegmentedControl<TodoSortBy>(
                groupValue: _sortBy,
                children: const {
                  TodoSortBy.createdAt: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Created'),
                  ),
                  TodoSortBy.dueDate: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Due Date'),
                  ),
                  TodoSortBy.priority: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    child: Text('Priority'),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    _sortBy = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 16),
            CupertinoListTile(
              title: const Text('Sort Ascending'),
              trailing: CupertinoSwitch(
                value: _sortAscending,
                onChanged: (value) {
                  setState(() {
                    _sortAscending = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 32),
            CupertinoButton.filled(
              onPressed: _handleApply,
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, Widget child) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: CupertinoColors.secondaryLabel,
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  Widget _buildTagChip(String label, bool isSelected) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _filterTag = label == 'All' ? null : label;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? CupertinoColors.activeBlue
              : CupertinoColors.systemGrey5,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? CupertinoColors.white
                : CupertinoColors.label,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

enum _CompletionFilter {
  all,
  active,
  completed,
}

enum _PriorityFilter {
  all,
  low,
  medium,
  high,
}
