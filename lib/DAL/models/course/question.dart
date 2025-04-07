class Question {
  final String task;
  final List<String> options;
  final String answer;

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
