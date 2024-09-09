import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageStudentsScreen extends StatefulWidget {
  @override
  _ManageStudentsScreenState createState() => _ManageStudentsScreenState();
}

class _ManageStudentsScreenState extends State<ManageStudentsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  String? _selectedStudentId; // To track the selected student for editing

  // Method to clear form after adding/updating
  void _clearForm() {
    _nameController.clear();
    _emailController.clear();
    _selectedStudentId = null;
  }

  // Method to add or update student
  Future<void> _saveStudent() async {
    if (_formKey.currentState!.validate()) {
      if (_selectedStudentId == null) {
        // Add new student
        await FirebaseFirestore.instance.collection('students').add({
          'name': _nameController.text,
          'email': _emailController.text,
          
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student added')),
        );
      } else {
        // Update existing student
        await FirebaseFirestore.instance
            .collection('students')
            .doc(_selectedStudentId)
            .update({
          'name': _nameController.text,
          'email': _emailController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Student updated')),
        );
      }
      _clearForm(); // Clear form after saving
    }
  }

  // Method to load student data into form for editing
  void _editStudent(DocumentSnapshot doc) {
    setState(() {
      _selectedStudentId = doc.id;
      _nameController.text = doc['name'];
      _emailController.text = doc['email'];
    });
  }

  // Method to delete student
  Future<void> _deleteStudent(String id) async {
    await FirebaseFirestore.instance.collection('students').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Student deleted')),
    );
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
          'Manage Students',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.0,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: 'Name'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a name' : null,
                  ),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                    validator: (value) =>
                        !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value!)
                            ? 'Please enter a valid email'
                            : null,
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: _saveStudent,
                    child: Text(_selectedStudentId == null
                        ? 'Add Student'
                        : 'Update Student'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('students')
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return ListView(
                    children: snapshot.data!.docs.map((doc) {
                      // Cast the document data to a Map<String, dynamic>
                      var data = doc.data() as Map<String, dynamic>;

                      // Handle null values by using default empty strings if null
                      String name = data['name'] != null
                          ? data['name']
                          : 'Unnamed Student';
                      String email =
                          data['email'] != null ? data['email'] : 'No Email';
                      String classId = data['classId'] != null
                          ? data['classId']
                          : 'No Class';

                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: Color.fromRGBO(227, 230, 232, 1),
                          title: Text(name),
                          subtitle: Text('Email: $email, Class ID: $classId'),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  _editStudent(doc); // Edit student function
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  _deleteStudent(
                                      doc.id); // Delete student function
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
