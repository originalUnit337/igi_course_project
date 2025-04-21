import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/course/question.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';
import 'package:igi_course_project/bloc/user_result/user_result_bloc.dart';
import 'package:igi_course_project/bloc/user_result/user_result_event.dart';
import 'package:igi_course_project/bloc/user_result/user_result_state.dart';

class CoursePage extends StatefulWidget {
  final Course course;
  final String userId; // Добавьте идентификатор пользователя
  const CoursePage({super.key, required this.course, required this.userId});

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  final Map<String, String?> userAnswers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.course.name),
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
          children: [
            // Отображение грамматических упражнений
            Text(
              'Grammar Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            ...widget.course.grammarExercises.map((exercise) {
              return ExpansionTile(
                title: Text(
                  exercise.type,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: exercise.questions.map((question) {
                  return QuestionWidget(
                    question: question,
                    onAnswerSelected: (selectedOption) {
                      setState(() {
                        userAnswers[question.task] =
                            selectedOption; // Сохраняем ответ
                      });
                    },
                  );
                }).toList(),
              );
            }).toList(),

            Text(
              'Reading Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),

            // Отображение чтения
            ...widget.course.readingExercises.map((exercise) {
              return ExpansionTile(
                title: Text(
                  exercise.type,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: exercise.questions.map((question) {
                  return QuestionWidget(
                    question: question,
                    onAnswerSelected: (selectedOption) {
                      setState(() {
                        userAnswers[question.task] =
                            selectedOption; // Сохраняем ответ
                      });
                    },
                  );
                }).toList(),
              );
            }).toList(),

            Text(
              'Audition Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),

            // Отображение аудирования
            ...widget.course.auditionExercises.map((exercise) {
              return ExpansionTile(
                title: Text(
                  exercise.type,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: exercise.questions.map((question) {
                  return QuestionWidget(
                    question: question,
                    onAnswerSelected: (selectedOption) {
                      setState(() {
                        userAnswers[question.task] =
                            selectedOption; // Сохраняем ответ
                      });
                    },
                  );
                }).toList(),
              );
            }).toList(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  List<String> correctAnswers = [];

                  // Сбор всех правильных ответов из всех типов упражнений
                  for (var exercise in widget.course.grammarExercises) {
                    for (var question in exercise.questions) {
                      correctAnswers.add(question.answer);
                    }
                  }

                  for (var exercise in widget.course.readingExercises) {
                    for (var question in exercise.questions) {
                      correctAnswers.add(question.answer);
                    }
                  }

                  for (var exercise in widget.course.auditionExercises) {
                    for (var question in exercise.questions) {
                      correctAnswers.add(question.answer);
                    }
                  }

                  // Подсчет баллов
                  double score = 0;
                  for (var exercise in widget.course.grammarExercises) {
                    for (var question in exercise.questions) {
                      // Используем question.task как ключ для userAnswers
                      String questionTask =
                          question.task; // Получаем текст задания
                      if (userAnswers[questionTask] == question.answer) {
                        // Сравниваем с правильным ответом
                        score++;
                      }
                    }
                  }

                  for (var exercise in widget.course.readingExercises) {
                    for (var question in exercise.questions) {
                      String questionTask =
                          question.task; // Получаем текст задания
                      if (userAnswers[questionTask] == question.answer) {
                        // Сравниваем с правильным ответом
                        score++;
                      }
                    }
                  }

                  for (var exercise in widget.course.auditionExercises) {
                    for (var question in exercise.questions) {
                      String questionTask =
                          question.task; // Получаем текст задания
                      if (userAnswers[questionTask] == question.answer) {
                        // Сравниваем с правильным ответом
                        score++;
                      }
                    }
                  }

                  // Вычисляем процент
                  score = (score / correctAnswers.length) *
                      100; // Оценка в процентах

                  // Создаем объект UserResult
                  final userResult = UserResult(
                    userId: widget.userId,
                    answers: userAnswers.values.toList(),
                    correctAnswers: correctAnswers,
                    score: score,
                    testDate: DateTime.now(),
                  );

                  // Сохраняем результаты
                  BlocProvider.of<UserResultBloc>(context).add(
                      SaveUserResultEvent(
                          widget.course.documentId, userResult));
                },
                child: Text('Сохранить результаты'),
              ),
            ),
          ],
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
