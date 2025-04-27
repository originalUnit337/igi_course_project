import 'package:igi_course_project/DAL/models/lesson/lesson.dart';

class Course {
  final String documentId;
  String title; // Название курса
  String language; // Язык курса
  String description; // Описание курса
  int popularity;
  List<Lesson> lessons; // Список уроков

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
        lessons = [];

  factory Course.fromJson(Map<String, dynamic> json, {String? id}) {
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
