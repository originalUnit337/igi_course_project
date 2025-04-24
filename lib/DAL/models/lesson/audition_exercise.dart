import 'question.dart';

class AuditionExercise {
  String type;
  String url;
  List<Question> questions;

  AuditionExercise({
    required this.type,
    required this.url,
    required this.questions,
  });

  factory AuditionExercise.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList =
        questionsFromJson.map((q) => Question.fromJson(q)).toList();

    return AuditionExercise(
      type: json['type'],
      url: json['url'],
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'url': url,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}
