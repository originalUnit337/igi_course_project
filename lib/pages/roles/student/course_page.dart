import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/question.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';
import 'package:igi_course_project/bloc/user_result/user_result_bloc.dart';
import 'package:igi_course_project/bloc/user_result/user_result_event.dart';
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
          return Center(
              child:
                  CircularProgressIndicator()); // Показываем индикатор загрузки
        } else if (state is UserResultSaved) {
          return Center(
              child:
                  Text('Результаты успешно сохранены!')); // Успешное сохранение
        } else if (state is UserResultError) {
          return Center(
              child: Text(
                  'Ошибка при сохранении результатов: ${state.message}')); // Ошибка
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

class QuestionWidget extends StatefulWidget {
  final Question question;
  final ValueChanged<String?> onAnswerSelected;

  const QuestionWidget(
      {super.key, required this.question, required this.onAnswerSelected});

  @override
  _QuestionWidgetState createState() => _QuestionWidgetState();
}

class _QuestionWidgetState extends State<QuestionWidget> {
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.question.task, style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Column(
              children: widget.question.options.map((option) {
                return RadioListTile<String>(
                  title: Text(option),
                  value: option,
                  groupValue: selectedOption,
                  onChanged: (value) {
                    setState(() {
                      selectedOption = value;
                    });
                    widget.onAnswerSelected(value);
                  },
                );
              }).toList(),
            ),
            if (selectedOption != null)
              Text(
                'Выбранный ответ: $selectedOption',
                style: TextStyle(color: Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
