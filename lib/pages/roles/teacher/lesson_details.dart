import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/lesson/audition_exercise.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/grammar_exercise.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/DAL/models/lesson/question.dart';
import 'package:igi_course_project/DAL/models/lesson/reading_exercise.dart';
import 'package:igi_course_project/DAL/models/lesson/written_exercise.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/bloc/course/course_event.dart';

class LessonDetails extends StatelessWidget {
  final Lesson lesson;
  final Course course;

  const LessonDetails({super.key, required this.lesson, required this.course});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(lesson.title),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Уроки'),
              //Tab(text: 'Результаты студентов'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AssignmentsList(
              lesson: lesson,
              course: course,
            ),
          ],
        ),
      ),
    );
  }
}

class AssignmentsList extends StatefulWidget {
  final Lesson lesson;
  final Course course;

  const AssignmentsList(
      {super.key, required this.lesson, required this.course});

  @override
  State<AssignmentsList> createState() => _AssignmentsListState();
}

class _AssignmentsListState extends State<AssignmentsList> {
  late TextEditingController _lessonNameController;
  late TextEditingController _lessonDescriptionController;
  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры с текущими значениями курса
    _lessonNameController = TextEditingController(text: widget.lesson.title);
    _lessonDescriptionController =
        TextEditingController(text: widget.lesson.description);
  }

  @override
  void dispose() {
    // Освобождаем контроллеры при уничтожении виджета
    _lessonNameController.dispose();
    _lessonDescriptionController.dispose();
    super.dispose();
  }

  void _updateCourseDetails() {
    setState(() {
      widget.lesson.title = _lessonNameController.text;
      widget.lesson.description = _lessonDescriptionController.text;
    });
  }

  void _addTheoryUrl() {
    String newUrl = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Добавить ссылку на теорию'),
          content: TextField(
            onChanged: (value) {
              newUrl = value;
            },
            decoration: InputDecoration(hintText: "Введите URL теории"),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  widget.lesson.theoryUrls.add(newUrl);
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
  }

  void _removeTheoryUrl(int index) {
    setState(() {
      widget.lesson.theoryUrls.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    void _saveCourseDetails(Course course, Lesson lesson) {
      // BlocProvider.of<CourseBloc>(context).add(UpdateLessonEvent(
      //     course.documentId, widget.lesson.documentId, lesson));
      BlocProvider.of<CourseBloc>(context).add(UpdateCourseEvent(course));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveCourseDetails(widget.course, widget.lesson),
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
                  controller: _lessonNameController,
                  decoration: InputDecoration(labelText: 'Название урока'),
                  onChanged: (value) => _updateCourseDetails(),
                ),
                TextField(
                  controller: _lessonDescriptionController,
                  decoration: InputDecoration(labelText: 'Описание урока'),
                  onChanged: (value) => _updateCourseDetails(),
                ),
              ],
            ),
          ),
          // Theory URLs Section
          ExpansionTile(
            title: Text('Ссылки на теорию'),
            children: [
              ...widget.lesson.theoryUrls.asMap().entries.map((entry) {
                int index = entry.key;
                String url = entry.value;
                return ListTile(
                  title: Text(url),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeTheoryUrl(index),
                  ),
                );
              }).toList(),
              ElevatedButton(
                onPressed: _addTheoryUrl,
                child: Text('Добавить ссылку на теорию'),
              ),
            ],
          ),
          // Grammar Exercises Section
          ExpansionTile(
            title: Text('Grammar Exercises'),
            children: [
              ...widget.lesson.grammarExercises.map((exercise) {
                return ExerciseWidget(
                  exercise: exercise,
                  onDelete: () {
                    setState(() {
                      widget.lesson.grammarExercises.remove(exercise);
                    });
                  },
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.lesson.grammarExercises.add(GrammarExercise(
                      type: 'Новый тип',
                      questions: [],
                    ));
                  });
                },
                child: Text('Добавить грамматическое упражнение'),
              ),
            ],
          ),

          // Reading Exercises Section
          ExpansionTile(
            title: Text('Reading Exercises'),
            children: [
              ...widget.lesson.readingExercises.map((exercise) {
                return ExerciseWidget(
                  exercise: exercise,
                  onDelete: () {
                    setState(() {
                      widget.lesson.readingExercises.remove(exercise);
                    });
                  },
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.lesson.readingExercises.add(ReadingExercise(
                      type: 'Новый тип',
                      text: 'Article text',
                      questions: [],
                    ));
                  });
                },
                child: Text('Добавить упражнение на чтение'),
              ),
            ],
          ),

          // Audition Exercises Section
          ExpansionTile(
            title: Text('Audition Exercises'),
            children: [
              ...widget.lesson.auditionExercises.map((exercise) {
                return ExerciseWidget(
                  exercise: exercise,
                  onDelete: () {
                    setState(() {
                      widget.lesson.auditionExercises.remove(exercise);
                    });
                  },
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.lesson.auditionExercises.add(AuditionExercise(
                      type: 'Новый тип',
                      url: 'place youtube url here',
                      questions: [],
                    ));
                  });
                },
                child: Text('Добавить упражнение на аудирование'),
              ),
            ],
          ),
          // Written Exercises Section
          ExpansionTile(
            title: Text('Written Exercises'),
            children: [
              ...widget.lesson.writtenExercises.map((exercise) {
                return WrittenExerciseWidget(
                  exercise: exercise,
                  onDelete: () {
                    setState(() {
                      widget.lesson.writtenExercises.remove(exercise);
                    });
                  },
                );
              }).toList(),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    widget.lesson.writtenExercises.add(WrittenExercise(
                      type: 'Новый тип',
                      task: 'Введите задание',
                      studentAnswer: '',
                    ));
                  });
                },
                child: Text('Добавить письменное задание'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class ExerciseWidget extends StatefulWidget {
  final dynamic
      exercise; // Это может быть GrammarExercise, ReadingExercise или AuditionExercise
  final VoidCallback onDelete;

  const ExerciseWidget(
      {super.key, required this.exercise, required this.onDelete});

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
            // Условное отображение полей в зависимости от типа упражнения
            if (widget.exercise is ReadingExercise) ...[
              TextField(
                decoration:
                    InputDecoration(labelText: 'Введите текст для чтения'),
                onChanged: (value) {
                  // Обновите соответствующее поле в ReadingExercise
                  (widget.exercise as ReadingExercise).text = value;
                },
              ),
            ] else if (widget.exercise is AuditionExercise) ...[
              TextField(
                decoration: InputDecoration(labelText: 'Введите URL аудио'),
                onChanged: (value) {
                  // Обновите соответствующее поле в AuditionExercise
                  (widget.exercise as AuditionExercise).url = value;
                },
              ),
            ],
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

class WrittenExerciseWidget extends StatefulWidget {
  final WrittenExercise exercise;
  final VoidCallback onDelete;

  const WrittenExerciseWidget({
    super.key,
    required this.exercise,
    required this.onDelete,
  });

  @override
  _WrittenExerciseWidgetState createState() => _WrittenExerciseWidgetState();
}

class _WrittenExerciseWidgetState extends State<WrittenExerciseWidget> {
  late TextEditingController _typeController;
  late TextEditingController _taskController;
  late TextEditingController _answerController;

  @override
  void initState() {
    super.initState();
    _typeController = TextEditingController(text: widget.exercise.type);
    _taskController = TextEditingController(text: widget.exercise.task);
    _answerController =
        TextEditingController(text: widget.exercise.studentAnswer);
  }

  @override
  void dispose() {
    _typeController.dispose();
    _taskController.dispose();
    _answerController.dispose();
    super.dispose();
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
              decoration: InputDecoration(labelText: 'Тип задания'),
              onChanged: (value) {
                setState(() {
                  widget.exercise.type = value; // Обновляем тип задания
                });
              },
            ),
            TextField(
              controller: _taskController,
              decoration: InputDecoration(labelText: 'Задание'),
              onChanged: (value) {
                setState(() {
                  widget.exercise.task = value; // Обновляем текст задания
                });
              },
            ),
            // TextField(
            //   controller: _answerController,
            //   decoration: InputDecoration(labelText: 'Ответ студента'),
            //   onChanged: (value) {
            //     setState(() {
            //       widget.exercise.studentAnswer =
            //           value; // Обновляем ответ студента
            //     });
            //   },
            // ),
            ElevatedButton(
              onPressed: widget.onDelete,
              child: Text('Удалить задание'),
            ),
          ],
        ),
      ),
    );
  }
}
