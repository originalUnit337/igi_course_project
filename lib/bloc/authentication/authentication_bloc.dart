import 'package:flutter_bloc/flutter_bloc.dart';

import '../../DAL/repositories/authentication_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthSignInEvent>(_authSignInEvent);
    on<AuthSignOutEvent>(_authSignOut);
  }

  Future<void> _authSignInEvent(
      AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(event.email, event.password);
      emit(AuthSignedIn(userId: user!.uid));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _authSignOut(
      AuthSignOutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(AuthInitial());
  }
}
