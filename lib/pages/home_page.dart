import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:igi_course_project/DAL/models/user_models/admin.dart';
import 'package:igi_course_project/DAL/models/user_models/student.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/DAL/models/user_models/user.dart';
import 'package:igi_course_project/bloc/authentication/authentication_bloc.dart';
import 'package:igi_course_project/bloc/authentication/authentication_event.dart';
import 'package:igi_course_project/bloc/authentication/authentication_state.dart';
import 'package:igi_course_project/pages/roles/admin/admin_page.dart';
import 'package:igi_course_project/pages/roles/student/student_page.dart';
import 'package:igi_course_project/pages/roles/teacher/teacher_Page.dart';
import 'package:igi_course_project/pages/welcome_page.dart';

import '../DAL/models/lesson/lesson.dart';
import '../bloc/course/course_bloc.dart';
import '../bloc/course/course_state.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Учебный портал по изучению иностранных языков'),
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
                    label: Text('Войти'),
                    icon: Icon(Icons.login),
                  ),
                  SizedBox(width: 20),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registrationPage');
                    },
                    label: Text('Зарегистрироваться'),
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
          } else if (currentUser is Teacher) {
            return BlocProvider(
                create: (context) => GetIt.I<AuthBloc>(),
                child: TeacherPage(currentUser: currentUser));
          } else if (currentUser is Student) {
            return StudentPage(currentUser: currentUser);
          } else {
            return WelcomePage();
          }
        });
      }),
    );
  }
}

Future<void> addCourse(Lesson course) async {
  try {
    CollectionReference courses =
        FirebaseFirestore.instance.collection('Courses');
    await courses.add(course.toJson());
    print('Course added successfully');
  } on Exception catch (e) {
    print(e.toString());
  }
}
