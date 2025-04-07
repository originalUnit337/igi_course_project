abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSignedIn extends AuthState {
  final String userId;

  AuthSignedIn({required this.userId});
}

class AuthError extends AuthState {
  final String message;

  AuthError({required this.message});
}
