import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/bloc/authentication/authentication_bloc.dart';
import 'package:igi_course_project/bloc/authentication/authentication_event.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DAL/models/course/course.dart';
import '../DAL/models/course/grammar_exercise.dart';
import '../DAL/models/course/question.dart';
import '../bloc/course/course_bloc.dart';
import '../bloc/course/course_event.dart';
import '../bloc/course/course_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<bool> _isUserLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userId') != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyglot Path'),
        centerTitle: true,
        actions: [
          FutureBuilder<bool>(
            future: _isUserLoggedIn(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator(); // Или любой другой индикатор загрузки
              } else if (snapshot.hasError) {
                return Text('Ошибка'); // Обработка ошибок
              } else if (snapshot.data == true) {
                // Если пользователь авторизован, показываем кнопку выхода
                return TextButton.icon(
                  onPressed: () async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.remove('userId');
                    await prefs.remove('role');
                  },
                  label: Text('Logout'),
                  icon: Icon(Icons.logout),
                );
              } else {
                // Если пользователь не авторизован, показываем кнопки логина и регистрации
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
            },
          ),
        ],
      ),
      body: BlocBuilder<CourseBloc, CourseState>(builder: (context, state) {
        switch (state) {
          case CourseLoading _:
            return Center(
              child: CircularProgressIndicator(),
            );
          case CourseLoaded _:
            return ListView.builder(
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: SizedBox(
                      width: 100,
                      height: 70,
                      child: Placeholder(),
                    ),
                    title: Text(state.courses[index].name),
                    subtitle: Text(state.courses[index].description),
                    onTap: () {
                      Navigator.pushNamed(context, '/previewCoursePage',
                          arguments: state.courses[index]);
                    },
                  );
                });
          case CourseError _:
            return Center(
              child: Text('Error: ${state.message}'),
            );
          default:
            return Center(
              child: Text('No courses available.'),
            );
        }
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
