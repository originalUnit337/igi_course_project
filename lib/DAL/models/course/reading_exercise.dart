import 'package:igi_course_project/DAL/models/course/question.dart';

class ReadingExercise {
  final String type;
  final List<Question> questions;

  ReadingExercise({
    required this.type,
    required this.questions,
  });

  factory ReadingExercise.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList = questionsFromJson
        .map((question) => Question.fromJson(question))
        .toList();

    return ReadingExercise(
      type: json['type'],
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}
