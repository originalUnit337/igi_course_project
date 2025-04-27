class UserResult {
  final String userId;
  final List<String?> testAnswers;
  final List<String> correctAnswers;
  final double score;
  final DateTime testDate;
  final List<String?> writtenExerciseAnswers;
  final List<String?> teacherFeedback;
  final bool isChecked;

  UserResult({
    required this.userId,
    required this.testAnswers,
    required this.correctAnswers,
    required this.score,
    required this.testDate,
    required this.writtenExerciseAnswers,
    required this.teacherFeedback,
    this.isChecked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answers': testAnswers,
      'correctAnswers': correctAnswers,
      'score': score,
      'testDate': testDate.toIso8601String(),
      'writtenExerciseAnswers': writtenExerciseAnswers,
      'teacherFeedback': teacherFeedback,
      'isChecked': isChecked,
    };
  }

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      userId: json['userId'],
      testAnswers: List<String?>.from(json['answers']),
      correctAnswers: List<String>.from(json['correctAnswers']),
      score: json['score'],
      testDate: DateTime.parse(json['testDate']),
      writtenExerciseAnswers:
          List<String?>.from(json['writtenExerciseAnswers'] ?? []),
      teacherFeedback: List<String?>.from(json['teacherFeedback'] ?? []),
      isChecked: json['isChecked'] ?? false,
    );
  }
}
