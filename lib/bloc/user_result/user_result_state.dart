import 'package:igi_course_project/DAL/models/user_result/user_result.dart';

abstract class UserResultState {}

class UserResultInitial extends UserResultState {}

class UserResultSaved extends UserResultState {}

class InProgress extends UserResultState {}

class UserResultLoaded extends UserResultState {
  //final UserResult userResult;
  final List<UserResult?> userResult;

  UserResultLoaded(this.userResult);
}

class UserResultError extends UserResultState {
  final String message;

  UserResultError(this.message);
}
