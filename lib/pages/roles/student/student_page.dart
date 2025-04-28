import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/user_models/student.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/bloc/course/course_event.dart';
import 'package:igi_course_project/bloc/course/course_state.dart';

class StudentPage extends StatelessWidget {
  final Student currentUser;

  const StudentPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Student Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Мои курсы'),
              Tab(text: 'Курсы, на которые не подписан'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            MyCoursesList(currentUser: currentUser),
            AvailableCoursesList(currentUser: currentUser),
          ],
        ),
      ),
    );
  }
}

class MyCoursesList extends StatelessWidget {
  final Student currentUser;

  const MyCoursesList({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CourseLoaded) {
          final subscribedCourses = currentUser.subscribedCourses;
          final myCourses = state.courses.where((course) {
            // Получаем ID из DocumentReference и сравниваем с documentId курса
            return subscribedCourses.any((ref) => ref.id == course.documentId);
          }).toList();

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
                    await Navigator.pushNamed(context, '/coursePage',
                        arguments: {
                          'course': myCourses[index],
                          'userId': currentUser.uid
                        });
                    context.mounted
                        ? BlocProvider.of<CourseBloc>(context)
                            .add(FetchCourseEvent())
                        : 0;
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Ошибка загрузки курсов'));
        }
      },
    );
  }
}

class AvailableCoursesList extends StatelessWidget {
  final Student currentUser;

  const AvailableCoursesList({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CourseLoaded) {
          final subscribedCourses = currentUser.subscribedCourses;

          final availableCourses = state.courses.where((course) {
            return !subscribedCourses.any((ref) => ref.id == course.documentId);
          }).toList();

          return ListView.builder(
            itemCount: availableCourses.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading:
                      Image.asset('course_img_${Random().nextInt(10) + 1}.png'),
                  title: Text(availableCourses[index].title),
                  subtitle: Text(availableCourses[index].description),
                  onTap: () {
                    Navigator.pushNamed(context, '/previewCoursePage',
                        arguments: availableCourses[index]);
                    context.mounted
                        ? BlocProvider.of<CourseBloc>(context)
                            .add(FetchCourseEvent())
                        : 0;
                  },
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Ошибка загрузки курсов'));
        }
      },
    );
  }
}
