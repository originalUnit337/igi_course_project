import 'package:igi_course_project/DAL/models/user_models/user.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedIn extends AuthState {
  final UserModel userModel;

  AuthSignedIn({required this.userModel});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}

class AuthSignedUp extends AuthState {
  final UserModel userModel;

  AuthSignedUp({required this.userModel});
}
