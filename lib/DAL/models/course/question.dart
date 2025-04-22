class Question {
  String task;
  List<String> options;
  String answer;

  Question({
    required this.task,
    required this.options,
    required this.answer,
  });

  factory Question.fromJson(Map<String, dynamic> json) {
    return Question(
      task: json['task'],
      options: List<String>.from(json['options']),
      answer: json['answer'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'task': task,
      'options': options,
      'answer': answer,
    };
  }
}
