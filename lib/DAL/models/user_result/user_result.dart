class UserResult {
  final String userId;
  final List<String?> answers;
  final List<String> correctAnswers;
  final double score;
  final DateTime testDate;

  UserResult({
    required this.userId,
    required this.answers,
    required this.correctAnswers,
    required this.score,
    required this.testDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'answers': answers,
      'correctAnswers': correctAnswers,
      'score': score,
      'testDate': testDate.toIso8601String(),
    };
  }

  factory UserResult.fromJson(Map<String, dynamic> json) {
    return UserResult(
      userId: json['userId'],
      answers: List<String?>.from(json['answers']),
      correctAnswers: List<String>.from(json['correctAnswers']),
      score: json['score'],
      testDate: DateTime.parse(json['testDate']),
    );
  }
}
