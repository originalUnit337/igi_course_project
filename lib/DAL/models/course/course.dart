import 'audition_exercise.dart';
import 'grammar_exercise.dart';
import 'reading_exercise.dart';

class Course {
  final int courseId;
  final String name;
  final String description;
  final String language;
  final List<GrammarExercise> grammarExercises;
  final List<ReadingExercise> readingExercises;
  final List<AuditionExercise> auditionExercises;

  Course({
    required this.courseId,
    required this.name,
    required this.description,
    required this.language,
    required this.grammarExercises,
    required this.readingExercises,
    required this.auditionExercises,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    var grammarExercisesFromJson = json['grammarExercises'] as List;
    var readingExercisesFromJson = json['readingExercises'] as List;
    var auditionExercisesFromJson = json['auditionExercises'] as List;

    List<GrammarExercise> grammarExercisesList = grammarExercisesFromJson
        .map((exercise) => GrammarExercise.fromJson(exercise))
        .toList();

    List<ReadingExercise> readingExercisesList = readingExercisesFromJson
        .map((e) => ReadingExercise.fromJson(e))
        .toList();

    List<AuditionExercise> auditionExercisesList = auditionExercisesFromJson
        .map((a) => AuditionExercise.fromJson(a))
        .toList();

    return Course(
      courseId: json['courseId'],
      name: json['name'],
      description: json['description'],
      language: json['language'],
      grammarExercises: grammarExercisesList,
      readingExercises: readingExercisesList,
      auditionExercises: auditionExercisesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'courseId': courseId,
      'name': name,
      'description': description,
      'language': language,
      'grammarExercises': grammarExercises.map((e) => e.toJson()).toList(),
      'readingExercises': readingExercises.map((e) => e.toJson()).toList(),
      'auditionExercises': auditionExercises.map((a) => a.toJson()).toList(),
    };
  }
}
