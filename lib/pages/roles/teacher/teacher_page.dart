import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/bloc/authentication/authentication_bloc.dart';
import 'package:igi_course_project/bloc/authentication/authentication_event.dart';
import 'package:igi_course_project/bloc/authentication/authentication_state.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/bloc/course/course_event.dart';
import 'package:igi_course_project/bloc/course/course_state.dart';

class TeacherPage extends StatelessWidget {
  Teacher currentUser;
  TeacherPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
        actions: [
          ElevatedButton(
            onPressed: () {
              BlocProvider.of<CourseBloc>(context)
                  .add(AddCourseEvent(Course.empty(), currentUser));
              BlocProvider.of<AuthBloc>(context)
                  .add(RefreshCurrentUserInfoEvent(currentUser));
            },
            child: Text('Add new course'),
          )
        ],
      ),
      // body: BlocListener<AuthBloc, AuthState>(
      //     listener: (context, state) {
      //       switch (state) {
      //         case Refreshed _:
      //           currentUser = state.userNodel as Teacher;
      //       }
      //     },
      //     child: MyCoursesList(currentUser: currentUser)),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
        switch (state) {
          case Refreshed _:
            currentUser = state.userNodel as Teacher;
            return MyCoursesList(currentUser: currentUser);
          default:
            return MyCoursesList(currentUser: currentUser);
        }
      }),
    );
  }
}

class MyCoursesList extends StatelessWidget {
  final Teacher currentUser;

  const MyCoursesList({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CourseLoaded) {
          final createdCourses = currentUser.createdCourses;
          final myCourses = state.courses.where((course) {
            return createdCourses.any((ref) => ref.id == course.documentId);
          }).toList();
          if (myCourses.isEmpty) {
            return Center(
              child: Column(
                children: [
                  Text('You do not have any created courses'),
                  ElevatedButton(
                    onPressed: () {
                      BlocProvider.of<CourseBloc>(context)
                          .add(AddCourseEvent(Course.empty(), currentUser));
                      BlocProvider.of<AuthBloc>(context)
                          .add(RefreshCurrentUserInfoEvent(currentUser));
                    },
                    child: Text('Add new course'),
                  ),
                ],
              ),
            );
          }
          return ListView.builder(
            itemCount: myCourses.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading:
                      Image.asset('course_img_${Random().nextInt(10) + 1}.png'),
                  title: Text(myCourses[index].title),
                  subtitle: Text(myCourses[index].description),
                  onTap: () async {
                    await Navigator.pushNamed(context, '/courseDetails',
                        arguments: {
                          'course': myCourses[index],
                          'userId': currentUser.uid
                        });
                  },
                ),
              );
            },
          );
        } else if (state is CourseError) {
          return Center(
              child: Text('Ошибка загрузки курсов: ${state.message}'));
        } else {
          return Center(
            child: Text('nothing'),
          );
        }
      },
    );
  }
}
