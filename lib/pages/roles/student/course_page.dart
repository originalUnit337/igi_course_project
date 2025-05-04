import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';
import 'package:igi_course_project/bloc/user_result/user_result_bloc.dart';
import 'package:igi_course_project/bloc/user_result/user_result_state.dart';

class CoursePage extends StatefulWidget {
  final Course course;
  final String userId;
  const CoursePage({super.key, required this.course, required this.userId});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.title),
      ),
      body: BlocBuilder<UserResultBloc, UserResultState>(
          builder: (context, state) {
        if (state is InProgress) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserResultSaved) {
          return Center(child: Text('Результаты успешно сохранены!'));
        } else if (state is UserResultError) {
          return Center(
              child:
                  Text('Ошибка при сохранении результатов: ${state.message}'));
        } else if (state is UserResultLoaded) {
          final userResults = state.userResult;

          return ListView(
            children: widget.course.lessons.map((lesson) {
              // Находим результат для текущего урока
              final userResult = userResults.firstWhere(
                (result) => result!.lessonName == lesson.title,
                orElse: () => UserResult(
                  userId: widget.userId,
                  courseId: widget.course.documentId,
                  lessonName: lesson.title,
                  testAnswers: [],
                  correctAnswers: [],
                  score: 0,
                  testDate: DateTime.now(),
                  writtenExerciseAnswers: [],
                  teacherFeedback: [],
                  isChecked: false,
                ),
              );

              Color tileColor =
                  userResult!.isChecked ? Colors.green : Colors.yellow;

              return ListTile(
                title: Text(lesson.title),
                tileColor: tileColor, // Устанавливаем цвет фона
                onTap: () {
                  if (userResult.isChecked) {
                    Navigator.pushNamed(context, '/resultPage', arguments: {
                      'userId': widget.userId,
                      'course': widget.course,
                      'lesson': lesson,
                      'userResult': userResult, // Передаем результат
                    });
                  } else {
                    Navigator.pushNamed(context, '/lessonPage', arguments: {
                      'userId': widget.userId,
                      'course': widget.course,
                      'lesson': lesson
                    });
                  }
                },
              );
            }).toList(),
          );
        }

        return ListView(
          children: widget.course.lessons.map((lesson) {
            return ListTile(
              title: Text(lesson.title),
              onTap: () {
                Navigator.pushNamed(context, '/lessonPage', arguments: {
                  'userId': widget.userId,
                  'course': widget.course,
                  'lesson': lesson
                });
              },
            );
          }).toList(),
        );
      }),
    );
  }
}
