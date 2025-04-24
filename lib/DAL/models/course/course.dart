import 'package:igi_course_project/DAL/models/lesson/lesson.dart';

class Course {
  final String documentId;
  String title; // Название курса
  String language; // Язык курса
  String description; // Описание курса
  List<Lesson> lessons; // Список уроков

  Course({
    required this.documentId,
    required this.title,
    required this.language,
    required this.description,
    required this.lessons,
  });

  Course.empty()
      : documentId = '',
        title = '',
        language = '',
        description = '',
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
      lessons: lessonsList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'language': language,
      'description': description,
      'lessons': lessons.map((lesson) => lesson.toJson()).toList(),
    };
  }
}
