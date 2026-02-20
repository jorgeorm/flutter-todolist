import 'package:flutter/cupertino.dart';

import '../models/todo.dart';

class AddTodoSheet extends StatefulWidget {
  const AddTodoSheet({required this.onSave, super.key});

  final Function(Todo) onSave;

  @override
  State<AddTodoSheet> createState() => _AddTodoSheetState();
}

class _AddTodoSheetState extends State<AddTodoSheet> {
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
