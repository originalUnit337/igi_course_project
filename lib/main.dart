import 'dart:js_interop';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:igi_course_project/DI/service_locator.dart';
import 'package:igi_course_project/firebase_options.dart';

import 'DAL/models/course/course.dart';
import 'bloc/course/course_bloc.dart';
import 'pages/home_page.dart';

void main() async {
  print('ola');
  await WidgetsFlutterBinding.ensureInitialized();
  Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('alo');
  // Dependency Injection
  setupLocator();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) => GetIt.I<CourseBloc>(),
        child: HomePage(),
      ),
    );
  }
}

Future<void> addCourse(Course course) async {
  CollectionReference courses =
      FirebaseFirestore.instance.collection('courses');

  await courses.add(course.toJson());
  print('Course added successfully');
}
