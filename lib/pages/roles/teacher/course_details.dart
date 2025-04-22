import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/audition_exercise.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/course/grammar_exercise.dart';
import 'package:igi_course_project/DAL/models/course/question.dart';
import 'package:igi_course_project/DAL/models/course/reading_exercise.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/bloc/course/course_event.dart';

class CourseDetails extends StatelessWidget {
  final Course course;

  const CourseDetails({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(course.name),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Задания'),
              Tab(text: 'Результаты студентов'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AssignmentsList(course: course),
            //StudentResultsList(course: course),
          ],
        ),
      ),
    );
  }
}

class AssignmentsList extends StatefulWidget {
  final Course course;

  const AssignmentsList({super.key, required this.course});

  @override
  State<AssignmentsList> createState() => _AssignmentsListState();
}

class _AssignmentsListState extends State<AssignmentsList> {
  late TextEditingController _courseNameController;
  late TextEditingController _courseDescriptionController;
  late TextEditingController _courseLanguageController;
  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры с текущими значениями курса
    _courseNameController = TextEditingController(text: widget.course.name);
    _courseDescriptionController =
        TextEditingController(text: widget.course.description);
    _courseLanguageController =
        TextEditingController(text: widget.course.language);
  }

  @override
  void dispose() {
    // Освобождаем контроллеры при уничтожении виджета
    _courseNameController.dispose();
    _courseDescriptionController.dispose();
    _courseLanguageController.dispose();
    super.dispose();
  }

  void _updateCourseDetails() {
    setState(() {
      widget.course.name = _courseNameController.text;
      widget.course.description = _courseDescriptionController.text;
      widget.course.language = _courseLanguageController.text;
    });
  }

  @override
  Widget build(BuildContext context) {
    void _saveCourseDetails(Course course) {
      BlocProvider.of<CourseBloc>(context).add(UpdateCourseEvent(course));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveCourseDetails(widget.course),
        tooltip: 'Сохранить изменения',
        child: Icon(Icons.save),
      ), // appBar: AppBar(
      //   title: Text('Редактировать ${widget.course.name}'),
      // ),
      body: ListView(
        children: [
          // Поля для редактирования названия, описания и языка курса
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _courseNameController,
                  decoration: InputDecoration(labelText: 'Название курса'),
                  onChanged: (value) => _updateCourseDetails(),
                ),
                TextField(
                  controller: _courseDescriptionController,
                  decoration: InputDecoration(labelText: 'Описание курса'),
                  onChanged: (value) => _updateCourseDetails(),
                ),
                TextField(
                  controller: _courseLanguageController,
                  decoration: InputDecoration(labelText: 'Язык курса'),
                  onChanged: (value) => _updateCourseDetails(),
                ),
              ],
            ),
          ),
          // Отображение грамматических упражнений
          Text(
            'Grammar Exercises',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...widget.course.grammarExercises.map((exercise) {
            return ExerciseWidget(
              exercise: exercise,
              onDelete: () {
                setState(() {
                  widget.course.grammarExercises.remove(exercise);
                });
              },
            );
          }).toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.course.grammarExercises.add(GrammarExercise(
                  type: 'Новый тип',
                  questions: [],
                ));
              });
            },
            child: Text('Добавить грамматическое упражнение'),
          ),

          // Аналогично для чтения
          Text(
            'Reading Exercises',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...widget.course.readingExercises.map((exercise) {
            return ExerciseWidget(
              exercise: exercise,
              onDelete: () {
                setState(() {
                  widget.course.readingExercises.remove(exercise);
                });
              },
            );
          }).toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.course.readingExercises.add(ReadingExercise(
                  type: 'Новый тип',
                  questions: [],
                ));
              });
            },
            child: Text('Добавить упражнение на чтение'),
          ),

          // Аналогично для аудирования
          Text(
            'Audition Exercises',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...widget.course.auditionExercises.map((exercise) {
            return ExerciseWidget(
              exercise: exercise,
              onDelete: () {
                setState(() {
                  widget.course.auditionExercises.remove(exercise);
                });
              },
            );
          }).toList(),
          ElevatedButton(
            onPressed: () {
              setState(() {
                widget.course.auditionExercises.add(AuditionExercise(
                  type: 'Новый тип',
                  questions: [],
                ));
              });
            },
            child: Text('Добавить упражнение на аудирование'),
          ),
        ],
      ),
    );
  }
}

class ExerciseWidget extends StatefulWidget {
  dynamic
      exercise; // Это может быть GrammarExercise, ReadingExercise или AuditionExercise
  final VoidCallback onDelete;

  ExerciseWidget({super.key, required this.exercise, required this.onDelete});

  @override
  State<ExerciseWidget> createState() => _ExerciseWidgetState();
}

class _ExerciseWidgetState extends State<ExerciseWidget> {
  late TextEditingController _typeController;
  @override
  void initState() {
    super.initState();
    // Инициализируем контроллер с текущим значением типа упражнения
    _typeController = TextEditingController(text: widget.exercise.type);
  }

  @override
  void dispose() {
    // Освобождаем контроллер при уничтожении виджета
    _typeController.dispose();
    super.dispose();
  }

  void _addNewQuestion() {
    // Создаем новый вопрос с предопределенными значениями
    final newQuestion = Question(
      task: 'ПРИМЕР ЗАДАНИЯ',
      options: [
        'ВАРИАНТ ОТВЕТА 1',
        'ВАРИАНТ ОТВЕТА 2',
        'ВАРИАНТ ОТВЕТА 3',
        'ВАРИАНТ ОТВЕТА 4',
      ],
      answer: 'ПРИМЕР ПРАВИЛЬНОГО ОТВЕТА',
    );

    // Добавляем новый вопрос в список и обновляем состояние
    setState(() {
      widget.exercise.questions.add(newQuestion);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _typeController,
              decoration: InputDecoration(labelText: 'Тип упражнения'),
              onChanged: (value) {
                setState(() {
                  widget.exercise.type = value; // Обновляем тип упражнения
                });
              },
            ),
            //Text(widget.exercise.type, style: TextStyle(fontSize: 16)),
            ...widget.exercise.questions.map((question) {
              return QuestionWidget(
                question: question,
                onDelete: () {
                  setState(() {
                    widget.exercise.questions
                        .remove(question); // Удаляем вопрос из списка
                  });
                },
                onAnswerSelected: (Question value) {},
              );
            }).toList(),
            ElevatedButton(
              onPressed: _addNewQuestion,
              child: Text('Добавить вопрос'),
            ),
            ElevatedButton(
              onPressed: widget.onDelete,
              child: Text('Удалить упражнение'),
            ),
          ],
        ),
      ),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  final Question question;
  final ValueChanged<Question> onAnswerSelected;
  final VoidCallback onDelete;

  const QuestionWidget({
    super.key,
    required this.question,
    required this.onAnswerSelected,
    required this.onDelete,
  });

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
            // Поле для редактирования текста вопроса
            TextField(
              controller: TextEditingController(text: widget.question.task),
              decoration: InputDecoration(labelText: 'Вопрос'),
              onChanged: (value) {
                widget.question.task = value;
              },
            ),
            SizedBox(height: 8),
            // Отображение вариантов ответов
            Column(
              children: widget.question.options.map((option) {
                return Row(
                  children: [
                    Expanded(
                      child: Text(option),
                    ),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        setState(() {
                          widget.question.options
                              .remove(option); // Удаляем вариант ответа
                        });
                      },
                    ),
                  ],
                );
              }).toList(),
            ),
            ElevatedButton(
              onPressed: () {
                // Логика для добавления нового варианта ответа
                showDialog(
                  context: context,
                  builder: (context) {
                    String newOptionText = '';
                    return AlertDialog(
                      title: Text('Добавить новый вариант ответа'),
                      content: TextField(
                        onChanged: (value) {
                          newOptionText = value;
                        },
                        decoration: InputDecoration(
                            hintText: "Введите текст варианта ответа"),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              widget.question.options.add(
                                  newOptionText); // Добавляем новый вариант
                            });
                            Navigator.of(context).pop();
                          },
                          child: Text('Добавить'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('Отмена'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: Text('Добавить вариант ответа'),
            ),
            SizedBox(height: 8),
            TextField(
              controller: TextEditingController(text: widget.question.answer),
              decoration: InputDecoration(labelText: 'Правильный ответ'),
              onChanged: (value) {
                widget.question.answer = value;
              },
            ),
            SizedBox(height: 8),
            ElevatedButton(
              onPressed: widget.onDelete,
              child: Text('Удалить вопрос'),
            ),
          ],
        ),
      ),
    );
  }
}

// class StudentResultsList extends StatelessWidget {
//   final Course course;

//   const StudentResultsList({super.key, required this.course});

//   @override
//   Widget build(BuildContext context) {
//     return BlocBuilder<CourseBloc, CourseState>(
//       builder: (context, state) {
//         if (state is CourseLoading) {
//           return Center(child: CircularProgressIndicator());
//         } else if (state is CourseLoaded) {
//           final studentResults = course.studentResults;

//           return ListView.builder(
//             itemCount: studentResults.length,
//             itemBuilder: (context, index) {
//               return Card(
//                 elevation: 4,
//                 margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//                 child: ListTile(
//                   title: Text(studentResults[index].studentName),
//                   subtitle: Text('Оценка: ${studentResults[index].grade}'),
//                 ),
//               );
//             },
//           );
//         } else {
//           return Center(child: Text('Ошибка загрузки результатов студентов'));
//         }
//       },
//     );
//   }
// }
