import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/user_models/student.dart';
import 'package:igi_course_project/DAL/models/user_models/user.dart';
import 'package:igi_course_project/bloc/authentication/authentication_bloc.dart';
import 'package:igi_course_project/bloc/authentication/authentication_state.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/bloc/course/course_event.dart';

import '../../DAL/models/course/course.dart';

class PreviewCoursePage extends StatelessWidget {
  final Course course;
  const PreviewCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview: ${course.title}'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text(
                course.title,
                style: Theme.of(context).textTheme.labelLarge,
              ),
              Text(course.description,
                  style: Theme.of(context).textTheme.bodyMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.language),
                  Text(course.language),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  final authState = BlocProvider.of<AuthBloc>(context).state;
                  String? userId;
                  UserModel? userModel;

                  if (authState is AuthSignedIn) {
                    userId = authState.userModel.uid;
                    userModel = authState.userModel;
                  }
                  if (userId != null && userModel is Student) {
                    BlocProvider.of<CourseBloc>(context).add(
                      SubscribeToCourseEvent(userId, course.documentId.toString()),
                    ); 
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Successfully subscribed')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please log in to subscribe.')),
                    );
                  }
                },
                child: Text('Subcribe'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
