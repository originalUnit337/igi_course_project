import 'package:equatable/equatable.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';

abstract class CourseState extends Equatable {
  @override
  List<Object> get props => [];
}

class CourseInitial extends CourseState {}

class CourseLoading extends CourseState {}

class CourseLoaded extends CourseState {
  final List<Course> courses;

  CourseLoaded(this.courses);

  @override
  List<Object> get props => [courses];
}

class CourseError extends CourseState {
  final String message;

  CourseError(this.message);

  @override
  List<Object> get props => [message];
}

class LessonsLoading extends CourseState {}

class LessonsLoaded extends CourseState {
  final List<Lesson> lessons;

  LessonsLoaded(this.lessons);
}

class LessonError extends CourseState {
  final String message;

  LessonError(this.message);
}