import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'package:flutter_application_1/screens/loginScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
    apiKey: 'AIzaSyAioLFv0jwHCRdNrZlXgzL3yWsuBt3SOnQ',
    appId: '1:86829265180:android:eb53b90b664008aa078ad9',
    messagingSenderId: '86829265180',
    projectId: 'schoolmanagementsystem-9db78',
    storageBucket: 'schoolmanagementsystem-9db78.appspot.com',
  ));

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    );
  }
}
