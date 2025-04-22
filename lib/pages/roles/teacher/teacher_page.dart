import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/bloc/course/course_state.dart';

class TeacherPage extends StatelessWidget {
  final Teacher currentUser;
  const TeacherPage({super.key, required this.currentUser});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Teacher Dashboard'),
      ),
      body: MyCoursesList(currentUser: currentUser),
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

          return ListView.builder(
            itemCount: myCourses.length,
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
                  title: Text(myCourses[index].name),
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
        } else {
          return Center(child: Text('Ошибка загрузки курсов'));
        }
      },
    );
  }
}
