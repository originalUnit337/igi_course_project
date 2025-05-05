import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../DAL/repositories/course_repository.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final CourseRepository courseRepository;

  CourseBloc(this.courseRepository) : super(CourseInitial()) {
    on<AddCourseEvent>(_onAddCourse);
    on<FetchCourseEvent>(_onFetchCourses);
    on<SubscribeToCourseEvent>(_onSubscribeToCourse);
    on<DeleteCourseEvent>(_onDeleteCourse);
    on<UpdateCourseEvent>(_onUpdateCourse);
    on<FetchLessonsEvent>(_onFetchLessons);
    on<UpdateLessonEvent>(_onUpdateLesson);

    add(FetchCourseEvent());
  }

  Future<void> _onAddCourse(
      AddCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      await courseRepository.addCourse(event.course, event.currentTeacher);
      final courses = await courseRepository.fetchCourses();
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  Future<void> _onFetchCourses(
      FetchCourseEvent event, Emitter<CourseState> emit) async {
    emit(CourseLoading());
    try {
      final courses = await courseRepository.fetchCourses();
      emit(CourseLoaded(courses));
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  FutureOr<void> _onSubscribeToCourse(
      SubscribeToCourseEvent event, Emitter<CourseState> emit) async {
    try {
      await courseRepository.subscribeToCourse(event.userId, event.courseId);
      add(FetchCourseEvent());
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  FutureOr<void> _onDeleteCourse(
      DeleteCourseEvent event, Emitter<CourseState> emit) async {
    try {
      await courseRepository.deleteCourse(event.courseId);
      add(FetchCourseEvent());
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateCourse(
      UpdateCourseEvent event, Emitter<CourseState> emit) async {
    try {
      emit(CourseLoading());
      await courseRepository.updateCourse(event.course);
      add(FetchCourseEvent());
    } catch (e) {
      emit(CourseError(e.toString()));
    }
  }

  FutureOr<void> _onFetchLessons(
      FetchLessonsEvent event, Emitter<CourseState> emit) async {
    emit(LessonsLoading());
    try {
      final lessons =
          await courseRepository.fetchLessons(event.course.documentId);
      emit(LessonsLoaded(lessons));
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }

  FutureOr<void> _onUpdateLesson(
      UpdateLessonEvent event, Emitter<CourseState> emit) async {
    try {
      emit(LessonsLoading());
      await courseRepository.updateLesson(
          event.courseId, event.lessonId, event.lesson);
    } catch (e) {
      emit(LessonError(e.toString()));
    }
  }
}
