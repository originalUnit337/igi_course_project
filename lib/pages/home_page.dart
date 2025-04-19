import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/user_models/admin.dart';
import 'package:igi_course_project/DAL/models/user_models/student.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/DAL/models/user_models/user.dart';
import 'package:igi_course_project/bloc/authentication/authentication_bloc.dart';
import 'package:igi_course_project/bloc/authentication/authentication_event.dart';
import 'package:igi_course_project/bloc/authentication/authentication_state.dart';
import 'package:igi_course_project/pages/roles/admin/admin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DAL/models/course/course.dart';
import '../DAL/models/course/grammar_exercise.dart';
import '../DAL/models/course/question.dart';
import '../bloc/course/course_bloc.dart';
import '../bloc/course/course_event.dart';
import '../bloc/course/course_state.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyglot Path'),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            if (state is AuthSignedIn || state is AuthSignedUp) {
              currentUser = (state as AuthSignedIn).userModel;
              return TextButton.icon(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(AuthSignOutEvent());
                },
                label: Text(currentUser!.email),
                icon: Icon(Icons.logout),
              );
            } else {
              return Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/loginPage');
                    },
                    label: Text('Login'),
                    icon: Icon(Icons.login),
                  ),
                  SizedBox(width: 20),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registrationPage');
                    },
                    label: Text('Register'),
                    icon: Icon(Icons.person_add),
                  ),
                ],
              );
            }
          }),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
        UserModel? currentUser;
        if (authState is AuthSignedIn || authState is AuthSignedUp) {
          currentUser = (authState as AuthSignedIn).userModel;
        }

        return BlocBuilder<CourseBloc, CourseState>(
            builder: (context, courseState) {
          if (currentUser is Admin) {
            return AdminPage();
            //return Center(child: Text('ADMIN'));
          } else if (currentUser is Teacher) {
            return Center(child: Text('TEACHER'));
          } else if (currentUser is Student) {
            return Center(child: Text('STUDENT'));
          } else {
            switch (courseState) {
              case CourseLoading _:
                return Center(child: CircularProgressIndicator());
              case CourseLoaded _:
                return ListView.builder(
                  itemCount: courseState.courses.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: SizedBox(
                          width: 100,
                          height: 70,
                          child: Placeholder(),
                        ),
                        title: Text(courseState.courses[index].name),
                        subtitle: Text(courseState.courses[index].description),
                        onTap: () {
                          Navigator.pushNamed(context, '/previewCoursePage',
                              arguments: courseState.courses[index]);
                        },
                      ),
                    );
                  },
                );
              case CourseError _:
                return Center(child: Text('Error: ${courseState.message}'));
              default:
                return Center(child: Text('No courses available.'));
            }
          }
        });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          //GetIt.I<CourseBloc>().add(FetchCourseEvent()),
          BlocProvider.of<CourseBloc>(context).add(FetchCourseEvent()),
        },
      ),
    );
  }
}

Future<void> addCourse(Course course) async {
  try {
    CollectionReference courses =
        FirebaseFirestore.instance.collection('Courses');
    await courses.add(course.toJson());
    print('Course added successfully');
  } on Exception catch (e) {
    print(e.toString());
  }
}
