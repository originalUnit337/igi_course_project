import 'package:equatable/equatable.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';

import '../../DAL/models/lesson/lesson.dart';

abstract class CourseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddCourseEvent extends CourseEvent {
  final Lesson course;
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
  final Lesson course;

  UpdateCourseEvent(this.course);
}
