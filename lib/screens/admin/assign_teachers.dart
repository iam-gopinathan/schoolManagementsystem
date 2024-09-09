import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AssignTeachersScreen extends StatefulWidget {
  @override
  _AssignTeachersScreenState createState() => _AssignTeachersScreenState();
}

class _AssignTeachersScreenState extends State<AssignTeachersScreen> {
  String? _selectedTeacher; // To hold the selected teacher ID
  String? _selectedClass; // To hold the selected class ID

  // Method to assign teacher to class
  Future<void> _assignTeacher() async {
    if (_selectedTeacher != null && _selectedClass != null) {
      try {
        print(
            'Updating document ID: $_selectedClass with teacher ID: $_selectedTeacher');
        await FirebaseFirestore.instance
            .collection('teachers')
            .doc(_selectedClass)
            .update({
          'teacherId': _selectedTeacher,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Teacher assigned successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both a teacher and a class')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          'Assign Teachers to Classes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Dropdown to select a teacher
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('teachers')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error fetching teachers'));
                    }

                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No teachers available'));
                    }

                    var teachers = snapshot.data!.docs;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton<String>(
                        hint: Text('Select Teacher'),
                        value: _selectedTeacher,
                        onChanged: (value) {
                          setState(() {
                            _selectedTeacher = value;
                          });
                        },
                        items: teachers.map((teacher) {
                          var data = teacher.data() as Map<String, dynamic>;
                          return DropdownMenuItem<String>(
                            value: teacher.id,
                            child: Text(data['name'] ?? 'No Name'),
                          );
                        }).toList(),
                        underline: SizedBox(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),

                // Dropdown to select a class
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('teachers')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Error fetching classes'));
                    }

                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.data!.docs.isEmpty) {
                      return Center(child: Text('No classes available'));
                    }

                    var classes = snapshot.data!.docs;

                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 50.0),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      child: DropdownButton<String>(
                        hint: Text('Select Class'),
                        value: _selectedClass,
                        onChanged: (value) {
                          setState(() {
                            _selectedClass = value;
                          });
                        },
                        items: classes.map((classDoc) {
                          var data = classDoc.data() as Map<String, dynamic>;
                          return DropdownMenuItem<String>(
                            value: classDoc.id,
                            child: Text(data['class'] ?? 'No Class'),
                          );
                        }).toList(),
                        underline: SizedBox(),
                      ),
                    );
                  },
                ),

                SizedBox(height: 20),

                // Button to assign teacher
                ElevatedButton(
                  onPressed: _assignTeacher,
                  child: Text('Assign Teacher'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
