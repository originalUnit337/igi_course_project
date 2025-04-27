class WrittenExercise {
  String type;
  String task;
  String studentAnswer;

  WrittenExercise(
      {required this.type, required this.task, this.studentAnswer = ''});

  factory WrittenExercise.fromJson(Map<String, dynamic> json) {
    return WrittenExercise(
      type: json['type'],
      task: json['task'],
      studentAnswer: json['studentAnswer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'task': task,
      'studentAnswer': studentAnswer,
    };
  }
}
