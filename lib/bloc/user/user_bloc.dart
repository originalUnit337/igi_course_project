import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/repositories/user_repository.dart';
import 'package:igi_course_project/bloc/user/user_event.dart';
import 'package:igi_course_project/bloc/user/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserRepository userRepository;

  UserBloc(this.userRepository) : super(UserInitial()) {
    on<FetchUserEvent>(_fetchUsers);
    on<BlockUserEvent>(_blockUser);

    add(FetchUserEvent());
  }

  Future<void> _fetchUsers(
      FetchUserEvent event, Emitter<UserState> emit) async {
    emit(UserLoading());
    try {
      final users = await userRepository.fetchUsers();
      emit(UserLoaded(users));
    } catch (e) {
      emit(UserError(e.toString()));
    }
  }

  FutureOr<void> _blockUser(
      BlockUserEvent event, Emitter<UserState> emit) async {
        try {
          await userRepository.blocUser(event.user, event.isBlocked);
        } catch (e) {

        }
      }
}
