import 'package:igi_course_project/DAL/models/user_result/user_result.dart';

abstract class UserResultEvent {}

class SaveUserResultEvent extends UserResultEvent {
  final String courseId;
  //final String lessonId;
  final UserResult userResult;

  SaveUserResultEvent(this.courseId, this.userResult);
}

class FetchUserResultEvent extends UserResultEvent {
  final String courseId;
  final String lessonId;
  //final String userId;

  FetchUserResultEvent(this.courseId, this.lessonId);
}

class FetchUserLessonsResults extends UserResultEvent {
  String userId;
  String courseId;

  FetchUserLessonsResults(this.userId, this.courseId);
}
