import 'package:equatable/equatable.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';


abstract class CourseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddCourseEvent extends CourseEvent {
  final Course course;
  final Teacher currentTeacher;

  AddCourseEvent(this.course, this.currentTeacher);

  @override
  List<Object> get props => [course];
}

class FetchCourseEvent extends CourseEvent {}

class SubscribeToCourseEvent extends CourseEvent {
  final String userId;
  final String courseId;

  SubscribeToCourseEvent(this.userId, this.courseId);
}

class DeleteCourseEvent extends CourseEvent {
  final String courseId;

  DeleteCourseEvent(this.courseId);
}

class UpdateCourseEvent extends CourseEvent {
  final Course course;

  UpdateCourseEvent(this.course);
}

class FetchLessonsEvent extends CourseEvent {
  final Course course;

  FetchLessonsEvent(this.course);
}

class UpdateLessonEvent extends CourseEvent {
  final String courseId;
  final String lessonId;
  final Lesson lesson;

  UpdateLessonEvent(this.courseId, this.lessonId, this.lesson);
}