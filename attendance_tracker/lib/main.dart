import 'package:flutter/material.dart';
import 'database_helper.dart'; // Import your database helper

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  late DatabaseHelper dbHelper;
  List<Map<String, dynamic>> _subjects = [];

  @override
  void initState() {
    super.initState();
    dbHelper = DatabaseHelper();
    _loadSubjects(); // Load subjects from the database
  }

  // Load subjects from database
  Future<void> _loadSubjects() async {
    final subjects = await dbHelper.getSubjects();
    setState(() {
      _subjects = subjects;
    });
  }

  // Add a new subject
  void _addSubject(String subjectName) async {
    if (subjectName.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Subject name cannot be empty!')),
      );
      return;
    }

    final subject = {
      'name': subjectName,
      'attended': 0,
      'total': 0,
    };

    await dbHelper.insertSubject(subject); // Insert into the database
    _loadSubjects(); // Refresh the subject list
  }

  // Remove a subject
  void _removeSubject(int id) async {
    await dbHelper.deleteSubject(id); // Delete from the database
    _loadSubjects(); // Refresh the subject list

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Subject has been removed!')),
    );
  }

  // Mark attendance for a subject
  void _markAttendance(int subjectId, bool present) async {
    final subject = _subjects.firstWhere((subject) => subject['id'] == subjectId);
    subject['total'] += 1;
    if (present) {
      subject['attended'] += 1;
    }

    await dbHelper.updateSubject(subject); // Update the subject in the database
    _loadSubjects(); // Refresh the subject list
  }

  // Calculate overall attendance
  double _calculateAttendancePercentage() {
    if (_subjects.isEmpty) return 100.0;

    int totalClasses = 0;
    int totalAttended = 0;

    for (var subject in _subjects) {
      totalClasses += (subject['total'] as int);
      totalAttended += (subject['attended'] as int);
    }

    return totalClasses == 0 ? 100.0 : (totalAttended / totalClasses) * 100;
  }

  // Show dialog to add a new subject
  void _showAddSubjectDialog(BuildContext context) {
    final TextEditingController _subjectController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Add Subject'),
        content: TextField(
          controller: _subjectController,
          decoration: InputDecoration(hintText: 'Enter subject name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_subjectController.text.isNotEmpty) {
                _addSubject(_subjectController.text.trim());
              }
              Navigator.of(ctx).pop();
            },
            child: Text('Add'),
          ),
        ],
      ),
    );
  }

  // Show dialog to mark attendance
  void _showMarkAttendanceDialog(BuildContext context, int subjectId, String subjectName) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Mark Attendance for $subjectName'),
        actions: [
          TextButton(
            onPressed: () {
              _markAttendance(subjectId, false);
              Navigator.of(ctx).pop();
            },
            child: Text('Absent'),
          ),
          ElevatedButton(
            onPressed: () {
              _markAttendance(subjectId, true);
              Navigator.of(ctx).pop();
            },
            child: Text('Present'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double attendancePercentage = _calculateAttendancePercentage();

    return Scaffold(
      appBar: AppBar(
        title: Text('Attendance Manager'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Dashboard Header
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: attendancePercentage < 75 ? Colors.redAccent : Colors.green,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overall Attendance',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '${attendancePercentage.toStringAsFixed(1)}%',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (attendancePercentage < 75)
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Text(
                          '⚠️ Attendance is below 75%! Attend more classes.',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 20),

            // Subject List
            Expanded(
              child: _subjects.isEmpty
                  ? Center(
                      child: Text(
                        'No subjects added yet! Use the "+" button to add subjects.',
                        style: TextStyle(fontSize: 16, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      itemCount: _subjects.length,
                      itemBuilder: (context, index) {
                        final subject = _subjects[index];
                        final subjectAttendance = subject['total'] == 0
                            ? 100.0
                            : (subject['attended'] / subject['total']) * 100;

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(subject['name']),
                            subtitle: Text(
                                'Attendance: ${subject['attended']}/${subject['total']} (${subjectAttendance.toStringAsFixed(1)}%)'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                  onPressed: () =>
                                      _showMarkAttendanceDialog(context, subject['id'], subject['name']),
                                ),
                                IconButton(
                                  icon: Icon(Icons.delete, color: Colors.red),
                                  onPressed: () {
                                    _removeSubject(subject['id']);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddSubjectDialog(context),
        child: Icon(Icons.add),
      ),
    );
  }
}