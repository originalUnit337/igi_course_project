import 'package:flutter/material.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';

class ResultPage extends StatelessWidget {
  final Lesson lesson;
  final Course course;
  final String userId;
  final UserResult userResult;

  const ResultPage({
    Key? key,
    required this.lesson,
    required this.course,
    required this.userId,
    required this.userResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int currentIndex = 0;
    return Scaffold(
      appBar: AppBar(
        title: Text(lesson.title),
      ),
      body: ListView(
        children: [
          // Отображение результатов для грамматических упражнений
          Text(
            'Grammar Exercises Results',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...lesson.grammarExercises.map((exercise) {
            return ExpansionTile(
              title: Text(
                exercise.type,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              children: exercise.questions.asMap().entries.map((entry) {
                //final index = entry.key;
                final question = entry.value;

                final userAnswer = currentIndex < userResult.testAnswers.length
                    ? userResult.testAnswers[currentIndex]
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
                              groupValue:
                                  userAnswer, // Устанавливаем выбранный ответ
                              onChanged: null, // Отключаем возможность выбора
                            );
                          }).toList(),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Ваш ответ: ${userAnswer ?? "Не ответили"}',
                          style: TextStyle(color: Colors.blue),
                        ),
                        Text('Правильный ответ: ${question.answer}'),
                        isCorrect
                            ? Text(
                                'Вы ответили верно !',
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                'Вы ответили неверно ',
                                style: TextStyle(color: Colors.red),
                              )
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
          ...lesson.readingExercises.map((exercise) {
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
                  //final index = entry.key;
                  final question = entry.value;
                  final userAnswer =
                      currentIndex < userResult.testAnswers.length
                          ? userResult.testAnswers[currentIndex]
                          : null; // Получаем ответ по индексу
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
                                groupValue:
                                    userAnswer, // Устанавливаем выбранный ответ
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
                                  'Вы ответили верно !',
                                  style: TextStyle(color: Colors.green),
                                )
                              : Text(
                                  'Вы ответили неверно ',
                                  style: TextStyle(color: Colors.red),
                                )
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            );
          }).toList(),

          // Отображение результатов для аудирования
          Text(
            'Audition Exercises Results',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...lesson.auditionExercises.map((exercise) {
            return ExpansionTile(
              title: Text(
                exercise.type,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              children: exercise.questions.asMap().entries.map((entry) {
                // final index = entry.key;
                final question = entry.value;
                final userAnswer = currentIndex < userResult.testAnswers.length
                    ? userResult.testAnswers[currentIndex]
                    : null; // Получаем ответ по индексу
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
                              groupValue:
                                  userAnswer, // Устанавливаем выбранный ответ
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
                                'Вы ответили верно !',
                                style: TextStyle(color: Colors.green),
                              )
                            : Text(
                                'Вы ответили неверно ',
                                style: TextStyle(color: Colors.red),
                              )
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }).toList(),

          // Отображение результатов для письменных упражнений
          Text(
            'Written Exercises Results',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...lesson.writtenExercises.map((exercise) {
            final index = lesson.writtenExercises.indexOf(exercise);
            final userAnswer = index < userResult.writtenExerciseAnswers.length
                ? userResult.writtenExerciseAnswers[index]
                : null; // Получаем ответ по индексу
            final feedback = index < userResult.teacherFeedback.length
                ? userResult.teacherFeedback[index]
                : null; // Получаем обратную связь от учителя по индексу

            return Card(
              margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(exercise.task, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 8),
                    Text(
                      'Ваш ответ: ${userAnswer ?? "Не ответили"}',
                      style: TextStyle(color: Colors.blue),
                    ),
                    SizedBox(height: 8),
                    // Вывод обратной связи от учителя, если она есть
                    if (feedback != null && feedback.isNotEmpty) ...[
                      Text(
                        'Обратная связь от учителя: $feedback',
                        style: TextStyle(color: Colors.black54),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }).toList(),

          // Отображение общего результата
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Общий балл: ${userResult.score.toStringAsFixed(2)}%',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
