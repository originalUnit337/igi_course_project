import 'audition_exercise.dart';
import 'grammar_exercise.dart';
import 'reading_exercise.dart';

class Course {
  final String documentId;
  String name;
  String description;
  String language;
  List<GrammarExercise> grammarExercises;
  List<ReadingExercise> readingExercises;
  List<AuditionExercise> auditionExercises;

  Course({
    required this.documentId,
    required this.name,
    required this.description,
    required this.language,
    required this.grammarExercises,
    required this.readingExercises,
    required this.auditionExercises,
  });

  factory Course.fromJson(Map<String, dynamic> json, {String? id}) {
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
      documentId: id ?? '',
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
      'name': name,
      'description': description,
      'language': language,
      'grammarExercises': grammarExercises.map((e) => e.toJson()).toList(),
      'readingExercises': readingExercises.map((e) => e.toJson()).toList(),
      'auditionExercises': auditionExercises.map((a) => a.toJson()).toList(),
    };
  }
}
