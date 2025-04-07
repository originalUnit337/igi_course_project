import 'package:igi_course_project/DAL/models/course/question.dart';

class AuditionExercise {
  final String type;
  final List<Question> questions;

  AuditionExercise({
    required this.type,
    required this.questions,
  });

  factory AuditionExercise.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList =
        questionsFromJson.map((q) => Question.fromJson(q)).toList();

    return AuditionExercise(
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
