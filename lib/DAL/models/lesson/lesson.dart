import 'audition_exercise.dart';
import 'grammar_exercise.dart';
import 'reading_exercise.dart';

class Lesson {
  final String documentId;
  String title;
  String description;
  String language;
  List<String> theoryUrls;
  List<GrammarExercise> grammarExercises;
  List<ReadingExercise> readingExercises;
  List<AuditionExercise> auditionExercises;

  Lesson({
    required this.documentId,
    required this.title,
    required this.description,
    required this.language,
    required this.theoryUrls,
    required this.grammarExercises,
    required this.readingExercises,
    required this.auditionExercises,
  });

  Lesson.empty()
      : documentId = '',
        title = '',
        description = '',
        language = '',
        theoryUrls = [],
        grammarExercises = [],
        readingExercises = [],
        auditionExercises = [];

  factory Lesson.fromJson(Map<String, dynamic> json, {String? id}) {
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

    return Lesson(
      documentId: id ?? '',
      title: json['name'],
      description: json['description'],
      language: json['language'],
      theoryUrls: List<String>.from(json['theoryUrls'] ?? []),
      grammarExercises: grammarExercisesList,
      readingExercises: readingExercisesList,
      auditionExercises: auditionExercisesList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': title,
      'description': description,
      'language': language,
      'theoryUrls': theoryUrls,
      'grammarExercises': grammarExercises.map((e) => e.toJson()).toList(),
      'readingExercises': readingExercises.map((e) => e.toJson()).toList(),
      'auditionExercises': auditionExercises.map((a) => a.toJson()).toList(),
    };
  }
}
