import 'package:igi_course_project/DAL/models/lesson/lesson.dart';

class Course {
  final String documentId;
  String title;
  String language;
  String description;
  int popularity;
  List<Lesson> lessons;

  Course({
    required this.documentId,
    required this.title,
    required this.language,
    required this.description,
    this.popularity = 0,
    required this.lessons,
  });

  Course.empty()
      : documentId = '',
        title = '',
        language = '',
        description = '',
        popularity = 0,
        lessons = [Lesson.empty()];

  factory Course.fromJson(Map<String, dynamic> json, {String? id}) {
    if (json['lessons'] != null) {
      var lessonsFromJson = json['lessons'] as List;
      List<Lesson> lessonsList =
          lessonsFromJson.map((lesson) => Lesson.fromJson(lesson)).toList();

      return Course(
        documentId: id ?? '',
        title: json['title'],
        language: json['language'],
        description: json['description'],
        popularity: json['popularity'],
        lessons: lessonsList,
      );
    } else {
      return Course(
        documentId: id ?? '',
        title: json['title'],
        language: json['language'],
        description: json['description'],
        popularity: json['popularity'],
        lessons: [],
      );
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'language': language,
      'description': description,
      'popularity': popularity,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
