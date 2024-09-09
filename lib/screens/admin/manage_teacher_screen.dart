import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ManageTeachersScreen extends StatefulWidget {
  @override
  _ManageTeachersScreenState createState() => _ManageTeachersScreenState();
}

class _ManageTeachersScreenState extends State<ManageTeachersScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _classController =
      TextEditingController(); // Controller for class input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
          'Manage Teachers',
          style: TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Form to add a teacher
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
                  TextFormField(
                    controller:
                        _classController, // Use this controller for class input
                    decoration: InputDecoration(labelText: 'Class'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a class' : null,
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        CollectionReference collRef =
                            FirebaseFirestore.instance.collection('teachers');
                        await collRef.add({
                          'name': _nameController.text,
                          'email': _emailController.text,
                          'class': _classController.text, // Save class name
                        });
                        _nameController.clear();
                        _emailController.clear();
                        _classController.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Teacher added')));
                      }
                    },
                    child: Text('Add Teacher'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              // Fetch and display the list of teachers
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('teachers')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  var teachers = snapshot.data!.docs;
                  return ListView.builder(
                    itemCount: teachers.length,
                    itemBuilder: (context, index) {
                      var teacher = teachers[index];
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          tileColor: Color.fromRGBO(227, 230, 232, 1),
                          title: Text(
                            (teacher.data() as Map<String, dynamic>?)
                                        ?.containsKey('name') ==
                                    true
                                ? (teacher.data()
                                        as Map<String, dynamic>)['name'] ??
                                    'No Name'
                                : 'No Name',
                          ),
                          subtitle: Text(
                            (teacher.data() as Map<String, dynamic>?)
                                        ?.containsKey('email') ==
                                    true
                                ? (teacher.data()
                                        as Map<String, dynamic>)['email'] ??
                                    'No Email'
                                : 'No Email',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onPressed: () {
                                  final data =
                                      teacher.data() as Map<String, dynamic>?;
                                  _nameController.text =
                                      data?.containsKey('name') == true
                                          ? data!['name'] ?? ''
                                          : '';
                                  _emailController.text =
                                      data?.containsKey('email') == true
                                          ? data!['email'] ?? ''
                                          : '';
                                  _classController.text =
                                      data?.containsKey('class') == true
                                          ? data!['class'] ?? ''
                                          : '';
                                  _showEditDialog(
                                      teacher.id); // Edit the teacher
                                },
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  FirebaseFirestore.instance
                                      .collection('teachers')
                                      .doc(teacher.id)
                                      .delete();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Teacher deleted')));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Dialog to edit teacher
  void _showEditDialog(String docId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Edit Teacher'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
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
                  TextFormField(
                    controller:
                        _classController, // Use this controller for class input
                    decoration: InputDecoration(labelText: 'Class'),
                    validator: (value) =>
                        value!.isEmpty ? 'Please enter a class' : null,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await FirebaseFirestore.instance
                      .collection('teachers')
                      .doc(docId)
                      .update({
                    'name': _nameController.text,
                    'email': _emailController.text,
                    'class': _classController.text, // Update class name
                  });
                  Navigator.pop(context);
                  _nameController.clear();
                  _emailController.clear();
                  _classController.clear();
                  ScaffoldMessenger.of(context)
                      .showSnackBar(SnackBar(content: Text('Teacher updated')));
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        );
      },
    );
  }
}
