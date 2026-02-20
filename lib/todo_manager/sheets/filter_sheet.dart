import 'package:flutter/cupertino.dart';

import '../services/todo_data_source.dart';
import '../models/todo.dart';
import '../todo_state.dart';

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

class FilterSheet extends StatefulWidget {
  const FilterSheet({
    required this.state,
    required this.onApply,
    required this.onClear,
    super.key,
  });

  final TodoState state;
  final Function(Map<String, dynamic>) onApply;
  final VoidCallback onClear;

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
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
