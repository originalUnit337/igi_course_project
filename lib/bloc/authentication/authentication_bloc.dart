import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../DAL/repositories/authentication_repository.dart';
import 'authentication_event.dart';
import 'authentication_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;

  AuthBloc(this._authRepository) : super(AuthInitial()) {
    on<AuthSignInEvent>(_authSignInEvent);
    on<AuthSignOutEvent>(_authSignOut);
    on<AuthSignUpEvent>(_authSignUpEvent);
    on<RefreshCurrentUserInfoEvent>(_refreshCurrentUserInfo);
  }

  Future<void> _authSignInEvent(
      AuthSignInEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user = await _authRepository.signIn(event.email, event.password);
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('userId', user!.uid);
      // await prefs.setString('role', 'user');
      emit(AuthSignedIn(userModel: user!));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  Future<void> _authSignOut(
      AuthSignOutEvent event, Emitter<AuthState> emit) async {
    await _authRepository.signOut();
    emit(AuthInitial());
  }

  Future<void> _authSignUpEvent(
      AuthSignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoading());
    try {
      final user =
          await _authRepository.signUp(event.email, event.password, event.role);
      // final prefs = await SharedPreferences.getInstance();
      // await prefs.setString('userId', user!.uid);
      // await prefs.setString('role', 'user');
      emit(AuthSignedIn(userModel: user!));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }

  FutureOr<void> _refreshCurrentUserInfo(
      RefreshCurrentUserInfoEvent event, Emitter<AuthState> emit) async {
    try {
      emit(RefreshInProgress());
      final user =
          await _authRepository.refreshCurrentUserInfo(event.currentUser);
      emit(Refreshed(userNodel: user));
    } catch (e) {
      emit(AuthError(message: e.toString()));
    }
  }
}
