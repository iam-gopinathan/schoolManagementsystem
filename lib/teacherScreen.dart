import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_1/screens/loginScreen.dart';

class Teacher extends StatefulWidget {
  const Teacher({super.key});

  @override
  State<Teacher> createState() => _TeacherState();
}

class _TeacherState extends State<Teacher> {
  // Method to fetch assigned classes
  Stream<List<Map<String, dynamic>>> _fetchAssignedClasses() {
    return FirebaseFirestore.instance
        .collection('teachers') // Collection where you store the classes
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => doc.data() as Map<String, dynamic>)
            .toList());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.blue,
        title: Text(
          'Teacher Screen',
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.translate(
              offset: Offset(0, -70),
              child: Text(
                'Welcome to student portal !',
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
                    builder: (context) => ViewAssignedClassesScreen(),
                  ),
                );
              },
              child: Text('View Classes'),
            ),
            SizedBox(
              height: 15,
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ViewstudentDetails(),
                  ),
                );
              },
              child: Text('View Student Details'),
            ),
          ],
        ),
      ),
    );
  }
}

class ViewAssignedClassesScreen extends StatelessWidget {
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
        title: Text(
          'Assigned Classes',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection('teachers')
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching classes'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return Center(child: Text('No classes assigned'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var classData = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: Color.fromRGBO(227, 230, 232, 1),
                  title: Text('Standard: ${classData['class'] ?? 'No Class'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                          'TeacherID: ${classData['teacherId'] ?? 'No Teacher Assigned'}'),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                            'Teacher Name: ${classData['name'] ?? 'No Teacher Assigned'}'),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ViewstudentDetails extends StatefulWidget {
  const ViewstudentDetails({super.key});

  @override
  State<ViewstudentDetails> createState() => _ViewstudentDetailsState();
}

class _ViewstudentDetailsState extends State<ViewstudentDetails> {
  void _markAttendance(String studentId) async {
    try {
      // You may need to create an attendance collection or add to existing one
      await FirebaseFirestore.instance.collection('attendance').add({
        'studentId': studentId,
        'date': Timestamp.now(),
        'status': 'Present', // or 'Absent'
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Attendance marked for student $studentId')),
      );
    } catch (e) {
      print('Error marking attendance: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to mark attendance')),
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
        title: Text(
          'View Student Details',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        backgroundColor: Colors.blue,
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: FirebaseFirestore.instance
            .collection(
                'students') 
            .snapshots()
            .map((snapshot) => snapshot.docs
                .map((doc) => doc.data() as Map<String, dynamic>)
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error fetching student details'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.isEmpty) {
            return Center(child: Text('No student details available'));
          }

          return ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              var studentData = snapshot.data![index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  tileColor: Color.fromRGBO(227, 230, 232, 1),
                  title: Text('Name: ${studentData['name'] ?? 'No Name'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Email: ${studentData['email'] ?? 'No Email'}'),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: Text(
                            'Class: ${studentData['class'] ?? 'No Class'}'),
                      ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: Icon(Icons.check, color: Colors.green),
                    onPressed: () => _markAttendance(studentData['studentId']),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
