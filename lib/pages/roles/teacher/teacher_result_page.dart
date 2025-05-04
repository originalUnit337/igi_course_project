import 'package:flutter/material.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';

class TeacherResultPage extends StatefulWidget {
  final Lesson lesson;
  final Course course;
  final String userId;
  final UserResult userResult;

  const TeacherResultPage({
    Key? key,
    required this.lesson,
    required this.course,
    required this.userId,
    required this.userResult,
  }) : super(key: key);

  @override
  _TeacherResultPageState createState() => _TeacherResultPageState();
}

class _TeacherResultPageState extends State<TeacherResultPage> {
  final List<TextEditingController> _feedbackControllers = [];

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < widget.lesson.writtenExercises.length; i++) {
      _feedbackControllers.add(TextEditingController());
    }
  }

  @override
  void dispose() {
    // Освобождение ресурсов контроллеров
    for (var controller in _feedbackControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _submitFeedback() {
    // Логика для отправки обратной связи
    // Здесь вы можете обработать отправку данных на сервер или в базу данных
    for (var controller in _feedbackControllers) {
      print(controller.text); // Пример вывода обратной связи в консоль
    }
    // После отправки можно очистить контроллеры или показать сообщение об успешной отправке
  }

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lesson.title),
      ),
      body: ListView(
        children: [
          // Отображение результатов для грамматических упражнений
          Text(
            'Grammar Exercises Results',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...widget.lesson.grammarExercises.map((exercise) {
            return ExpansionTile(
              title: Text(
                exercise.type,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              children: exercise.questions.asMap().entries.map((entry) {
                final question = entry.value;
                final userAnswer =
                    currentIndex < widget.userResult.testAnswers.length
                        ? widget.userResult.testAnswers[currentIndex]
                        : null;
                final isCorrect = userAnswer == question.answer;

                currentIndex++;
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(question.task, style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        // Отображение вариантов ответов в виде радио-кнопок
                        Column(
                          children: question.options.map((option) {
                            return RadioListTile<String>(
                              title: Text(option),
                              value: option,
                              groupValue: userAnswer,
                              onChanged: null, // Отключаем возможность выбора
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ваш ответ: ${userAnswer ?? "Не ответили"}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        isCorrect
                            ? Text(
                                'Вы ответили верно!',
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                'Вы ответили неверно',
                                style: TextStyle(color: Colors.red),
                              ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),

          // Отображение результатов для чтения
          Text(
            'Reading Exercises Results',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...widget.lesson.readingExercises.map((exercise) {
            return ExpansionTile(
              title: Text(
                exercise.type,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    exercise.text,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                ...exercise.questions.asMap().entries.map((entry) {
                  final question = entry.value;
                  final userAnswer =
                      currentIndex < widget.userResult.testAnswers.length
                          ? widget.userResult.testAnswers[currentIndex]
                          : null;
                  final isCorrect = userAnswer == question.answer;

                  currentIndex++;
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(question.task, style: TextStyle(fontSize: 16)),
                          SizedBox(height: 8),
                          // Отображение вариантов ответов в виде радио-кнопок
                          Column(
                            children: question.options.map((option) {
                              return RadioListTile<String>(
                                title: Text(option),
                                value: option,
                                groupValue: userAnswer,
                                onChanged: null, // Отключаем возможность выбора
                              );
                            }).toList(),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Ваш ответ: ${userAnswer ?? "Не ответили"}',
                            style: TextStyle(color: Colors.blue),
                          ),
                          isCorrect
                              ? Text(
                                  'Вы ответили верно!',
                                  style: TextStyle(color: Colors.green),
                                )
                              : Text(
                                  'Вы ответили неверно',
                                  style: TextStyle(color: Colors.red),
                                ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),

          // Отображение письменных упражнений
          Text(
            'Written Exercises Feedback',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...widget.lesson.writtenExercises.asMap().entries.map((entry) {
            final index = entry.key;
            final exercise = entry.value;

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercise.task, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text(widget.userResult.writtenExerciseAnswers[index] ??
                        'Нет ответа'),
                    TextField(
                      controller: _feedbackControllers[index],
                      decoration: InputDecoration(
                        labelText: 'Введите обратную связь',
                        border: OutlineInputBorder(),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            );
          }).toList(),

          // Кнопка для отправки обратной связи
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _submitFeedback,
              child: Text('Отправить feedback'),
            ),
          ),

          // Отображение общего результата
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Общий балл: ${widget.userResult.score.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
