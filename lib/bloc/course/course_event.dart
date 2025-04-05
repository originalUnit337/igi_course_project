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
 