import 'question.dart';

class ReadingExercise {
  String type;
  String text;
  List<Question> questions;

  ReadingExercise({
    required this.type,
    required this.text,
    required this.questions,
  });

  factory ReadingExercise.fromJson(Map<String, dynamic> json) {
    var questionsFromJson = json['questions'] as List;
    List<Question> questionsList = questionsFromJson
        .map((question) => Question.fromJson(question))
        .toList();

    return ReadingExercise(
      type: json['type'],
      text: json['text'],
      questions: questionsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'text': text,
      'questions': questions.map((question) => question.toJson()).toList(),
    };
  }
}
