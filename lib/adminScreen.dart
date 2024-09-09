import 'package:flutter/material.dart';
import 'package:flutter_application_1/screens/admin/assign_teachers.dart';
import 'package:flutter_application_1/screens/admin/manage_student_screen.dart';
import 'package:flutter_application_1/screens/admin/manage_teacher_screen.dart';

import 'package:flutter_application_1/screens/loginScreen.dart';

class Admin extends StatefulWidget {
  const Admin({super.key});

  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => LoginScreen()));
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          'Admin Dashboard',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.translate(
                offset: Offset(0, -70),
                child: Text(
                  'Welcome to Admin portal!',
                  style: TextStyle(color: Colors.blue, fontSize: 18.0),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageStudentsScreen()),
                  );
                },
                child: Text('Manage Students'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageTeachersScreen()),
                  );
                },
                child: Text('Manage Teachers'),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AssignTeachersScreen()),
                  );
                },
                child: Text('Assign Teachers to Classes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
