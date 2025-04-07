import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/repositories/course_repository.dart';
import 'package:igi_course_project/bloc/course/course_state.dart';

import 'course_event.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository courseRepository;

  CourseBloc(this.courseRepository) : super(CourseInitial()) {
    on<AddCourseEvent>(_onAddCourse);
    on<FetchCourseEvent>(_onFetchCourses);
  }

  Future<void> _onAddCourse(AddCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      await courseRepository.addCourse(event.course);
      final courses = await courseRepository.fetchCourses();
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onFetchCourses(FetchCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      final courses = await courseRepository.fetchCourses();
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }
}