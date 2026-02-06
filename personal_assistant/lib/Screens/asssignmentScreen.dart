import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:personal_assistant/models/assignment.dart';
import 'package:personal_assistant/providers/assignment_provider.dart';

class AssignmentManagementScreen extends StatefulWidget {
  const AssignmentManagementScreen({super.key});

  @override
  State<AssignmentManagementScreen> createState() =>
      _AssignmentManagementScreenState();
}

class _AssignmentManagementScreenState
    extends State<AssignmentManagementScreen> {
  final _titleController = TextEditingController();
  final _courseController = TextEditingController();
  DateTime? _selectedDate;
  String _selectedPriority = 'Medium';
  final _formKey = GlobalKey<FormState>();
  Assignment? _assignmentToEdit;
  final _dateController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _courseController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  void _addOrUpdateAssignment() {
    if (_formKey.currentState!.validate()) {
      final assignment = Assignment(
        id: _assignmentToEdit?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        dueDate: _selectedDate!,
        courseName: _courseController.text,
        priority: _selectedPriority,
        isCompleted: _assignmentToEdit?.isCompleted ?? false,
      );

      final assignmentProvider =
      Provider.of<AssignmentProvider>(context, listen: false);

      if (_assignmentToEdit != null) {
        assignmentProvider.updateAssignment(assignment);
      } else {
        assignmentProvider.addAssignment(assignment);
      }

      _resetForm();
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_assignmentToEdit != null
              ? 'Assignment updated successfully!'
              : 'Assignment added successfully!'),
          backgroundColor: Colors.green,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  void _deleteAssignment(String id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this assignment?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final assignmentProvider =
              Provider.of<AssignmentProvider>(context, listen: false);
              assignmentProvider.deleteAssignment(id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Assignment deleted'),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            },
            child: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  void _toggleCompletion(String id) {
    final assignmentProvider =
    Provider.of<AssignmentProvider>(context, listen: false);
    assignmentProvider.toggleCompletion(id);
  }

  void _editAssignment(Assignment assignment) {
    _assignmentToEdit = assignment;
    _titleController.text = assignment.title;
    _courseController.text = assignment.courseName;
    _selectedDate = assignment.dueDate;
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    _selectedPriority = assignment.priority;
    _showAssignmentDialog();
  }

  void _resetForm() {
    _titleController.clear();
    _courseController.clear();
    _selectedDate = DateTime.now();
    _dateController.text = DateFormat('yyyy-MM-dd').format(_selectedDate!);
    _selectedPriority = 'Medium';
    _assignmentToEdit = null;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.deepPurple,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            dialogBackgroundColor: Colors.white,
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  void _showAssignmentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            _assignmentToEdit != null ? 'Edit Assignment' : 'Add New Assignment',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: 'Assignment Title *',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.title),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter assignment title';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _selectDate(context),
                    child: AbsorbPointer(
                      child: TextFormField(
                        controller: _dateController,
                        decoration: InputDecoration(
                          labelText: 'Due Date *',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          prefixIcon: const Icon(Icons.calendar_today),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.calendar_month),
                            onPressed: () => _selectDate(context),
                          ),
                        ),
                        readOnly: true,
                        validator: (value) {
                          if (_selectedDate == null) {
                            return 'Please select a due date';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _courseController,
                    decoration: InputDecoration(
                      labelText: 'Course Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.school),
                    ),
                  ),
                  const SizedBox(height: 16),
                  DropdownButtonFormField<String>(
                    value: _selectedPriority,
                    decoration: InputDecoration(
                      labelText: 'Priority Level',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      prefixIcon: const Icon(Icons.priority_high),
                    ),
                    items: ['High', 'Medium', 'Low']
                        .map((priority) => DropdownMenuItem(
                      value: priority,
                      child: Row(
                        children: [
                          Icon(
                            priority == 'High'
                                ? Icons.arrow_upward
                                : priority == 'Medium'
                                ? Icons.arrow_right
                                : Icons.arrow_downward,
                            color: _getPriorityColor(priority),
                          ),
                          const SizedBox(width: 8),
                          Text(priority),
                        ],
                      ),
                    ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() {
                          _selectedPriority = value;
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _resetForm();
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: _addOrUpdateAssignment,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: Text(_assignmentToEdit != null ? 'Update' : 'Add'),
            ),
          ],
        );
      },
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final assignments = Provider.of<AssignmentProvider>(context).assignments;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Assignment Management'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        elevation: 3,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _resetForm();
          _showAssignmentDialog();
        },
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
        child: const Icon(Icons.add),
      ),
      body: assignments.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.assignment_outlined,
              size: 100,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 20),
            Text(
              'No assignments yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                'Tap the + button to add your first assignment',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[500],
                ),
              ),
            ),
          ],
        ),
      )
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.filter_list, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(
                  '${assignments.length} assignment${assignments.length == 1 ? '' : 's'}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.deepPurple,
                  ),
                ),
                const Spacer(),
                Chip(
                  label: Text(
                    '${assignments.where((a) => !a.isCompleted).length} pending',
                    style: const TextStyle(color: Colors.white),
                  ),
                  backgroundColor: Colors.deepPurple,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: assignments.length,
              itemBuilder: (context, index) {
                final assignment = assignments[index];
                final now = DateTime.now();
                final isOverdue = assignment.dueDate.isBefore(now) && !assignment.isCompleted;
                final daysUntilDue = assignment.dueDate.difference(now).inDays;

                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: assignment.isCompleted
                            ? Colors.green.withOpacity(0.1)
                            : _getPriorityColor(assignment.priority)
                            .withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Checkbox(
                          value: assignment.isCompleted,
                          onChanged: (_) =>
                              _toggleCompletion(assignment.id),
                          shape: const CircleBorder(),
                          activeColor: Colors.green,
                        ),
                      ),
                    ),
                    title: Row(
                      children: [
                        Expanded(
                          child: Text(
                            assignment.title,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              decoration: assignment.isCompleted
                                  ? TextDecoration.lineThrough
                                  : null,
                              color: assignment.isCompleted
                                  ? Colors.grey
                                  : null,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(assignment.priority)
                                .withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: _getPriorityColor(
                                  assignment.priority),
                              width: 1,
                            ),
                          ),
                          child: Text(
                            assignment.priority,
                            style: TextStyle(
                              fontSize: 12,
                              color: _getPriorityColor(assignment.priority),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Icon(
                              Icons.school,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              assignment.courseName,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: 14,
                              color: isOverdue
                                  ? Colors.red
                                  : Colors.blue,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('MMM dd, yyyy')
                                  .format(assignment.dueDate),
                              style: TextStyle(
                                fontSize: 14,
                                color: isOverdue
                                    ? Colors.red
                                    : Colors.grey[700],
                                fontWeight: isOverdue
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                            if (isOverdue)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.red.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.red,
                                    width: 1,
                                  ),
                                ),
                                child: const Text(
                                  'OVERDUE',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (!isOverdue && daysUntilDue <= 7 && !assignment.isCompleted)
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Colors.orange,
                                    width: 1,
                                  ),
                                ),
                                child: Text(
                                  daysUntilDue == 0
                                      ? 'Due Today'
                                      : daysUntilDue == 1
                                      ? 'Tomorrow'
                                      : '$daysUntilDue days',
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.orange,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                    trailing: PopupMenuButton(
                      icon: const Icon(Icons.more_vert),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit,
                                  size: 20, color: Colors.deepPurple),
                              const SizedBox(width: 8),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: const [
                              Icon(Icons.delete, color: Colors.red, size: 20),
                              SizedBox(width: 8),
                              Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                            ],
                          ),
                        ),
                      ],
                      onSelected: (value) {
                        if (value == 'edit') {
                          _editAssignment(assignment);
                        } else if (value == 'delete') {
                          _deleteAssignment(assignment.id);
                        }
                      },
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}