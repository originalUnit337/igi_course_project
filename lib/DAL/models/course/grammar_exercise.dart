import 'question.dart';

class GrammarExercise {
  String type;
  List<Question> questions;

  GrammarExercise({
    required this.type,
    required this.questions,
  });

  factory GrammarExercise.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList = questionsFromJson
        .map((question) => Question.fromJson(question))
        .toList();

    return GrammarExercise(
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
