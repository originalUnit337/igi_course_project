import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/DAL/models/lesson/question.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';
import 'package:igi_course_project/bloc/user_result/user_result_bloc.dart';
import 'package:igi_course_project/bloc/user_result/user_result_event.dart';
import 'package:igi_course_project/bloc/user_result/user_result_state.dart';

class LessonPage extends StatefulWidget {
  final Lesson lesson;
  final Course course;
  final String userId;
  const LessonPage(
      {super.key,
      required this.course,
      required this.userId,
      required this.lesson});

  @override
  State<LessonPage> createState() => _LessonPageState();
}

class _LessonPageState extends State<LessonPage> {
  final Map<String, String?> userAnswers = {};
  final Map<String, String?> writtenExerciseAnswers =
      {}; // Для письменных упражнений

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
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
            ...widget.lesson.grammarExercises.map((exercise) {
              return ExpansionTile(
                title: Text(
                  exercise.type,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: exercise.questions.map((question) {
                  return QuestionWidget(
                    question: question,
                    onAnswerSelected: (selectedOption) {
                      // Обработка выбора ответа
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
            Text(
              'Grammar Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            ...widget.lesson.readingExercises.map((exercise) {
              return ExpansionTile(
                title: Text(
                  exercise.type,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: exercise.questions.map((question) {
                  return QuestionWidget(
                    question: question,
                    onAnswerSelected: (selectedOption) {
                      // Обработка выбора ответа
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
            Text(
              'Grammar Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            ...widget.lesson.auditionExercises.map((exercise) {
              return ExpansionTile(
                title: Text(
                  exercise.type,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                children: exercise.questions.map((question) {
                  return QuestionWidget(
                    question: question,
                    onAnswerSelected: (selectedOption) {
                      // Обработка выбора ответа
                    },
                  );
                }).toList(),
              );
            }).toList(),

            Text(
              'Written Exercises',
              style: Theme.of(context).textTheme.displayLarge,
              textAlign: TextAlign.center,
            ),
            // Отображение письменных упражнений
            ...widget.lesson.writtenExercises.map((exercise) {
              return Card(
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(exercise.task, style: TextStyle(fontSize: 16)),
                      SizedBox(height: 8),
                      TextField(
                        onChanged: (value) {
                          setState(() {
                            userAnswers[exercise.task] = value;
                            // Сохраняем ответ в userAnswers
                          });
                        },
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Введите ваш ответ',
                        ),
                      ),
                      SizedBox(height: 8),
                      if (userAnswers[exercise.task] != null)
                        Text(
                          'Ваш ответ: ${userAnswers[exercise.task]}',
                          style: TextStyle(color: Colors.blue),
                        ),
                    ],
                  ),
                ),
              );
            }).toList(),

            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                onPressed: () {
                  List<String> correctAnswers = [];
                  List<String?> writtenAnswers =
                      []; // Для хранения ответов на письменные упражнения

                  // Сбор всех правильных ответов из всех типов упражнений
                  for (var lesson in widget.course.lessons) {
                    for (var exercise in lesson.grammarExercises) {
                      for (var question in exercise.questions) {
                        correctAnswers.add(question.answer);
                      }
                    }

                    for (var exercise in lesson.readingExercises) {
                      for (var question in exercise.questions) {
                        correctAnswers.add(question.answer);
                      }
                    }

                    for (var exercise in lesson.auditionExercises) {
                      for (var question in exercise.questions) {
                        correctAnswers.add(question.answer);
                      }
                    }

                    for (var exercise in lesson.writtenExercises) {
                      writtenAnswers.add(writtenExerciseAnswers[
                          exercise.task]); // Добавляем ответ студента
                    }
                  }

                  // Подсчет баллов
                  double score = 0;
                  for (var lesson in widget.course.lessons) {
                    for (var exercise in lesson.grammarExercises) {
                      for (var question in exercise.questions) {
                        String questionTask =
                            question.task; // Получаем текст задания
                        if (userAnswers[questionTask] == question.answer) {
                          score++;
                        }
                      }
                    }

                    for (var exercise in lesson.readingExercises) {
                      for (var question in exercise.questions) {
                        String questionTask =
                            question.task; // Получаем текст задания
                        if (userAnswers[questionTask] == question.answer) {
                          score++;
                        }
                      }
                    }

                    for (var exercise in lesson.auditionExercises) {
                      for (var question in exercise.questions) {
                        String questionTask =
                            question.task; // Получаем текст задания
                        if (userAnswers[questionTask] == question.answer) {
                          score++;
                        }
                      }
                    }
                  }

                  // Вычисляем процент
                  score = (score / correctAnswers.length) *
                      100; // Оценка в процентах

                  // Создаем объект UserResult
                  final userResult = UserResult(
                    userId: widget.userId,
                    testAnswers: userAnswers.values.toList(),
                    correctAnswers: correctAnswers,
                    score: score,
                    testDate: DateTime.now(),
                    writtenExerciseAnswers: writtenAnswers,
                    teacherFeedback: [],
                  );

                  // Сохраняем результаты
                  // BlocProvider.of<UserResultBloc>(context).add(
                  //     SaveUserResultEvent(
                  //         widget.course.documentId, userResult));
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
