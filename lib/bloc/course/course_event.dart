import 'package:equatable/equatable.dart';

import '../../DAL/models/course/course.dart';

abstract class CourseEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddCourseEvent extends CourseEvent {
  final Course course;

  AddCourseEvent(this.course);

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
