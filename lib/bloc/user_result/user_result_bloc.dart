import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';
import 'package:igi_course_project/DAL/repositories/user_result_repository.dart';
import 'package:igi_course_project/bloc/user_result/user_result_event.dart';
import 'package:igi_course_project/bloc/user_result/user_result_state.dart';

class UserResultBloc extends Bloc<UserResultEvent, UserResultState> {
  final UserResultRepository userResultRepository;

  UserResultBloc(this.userResultRepository) : super(UserResultInitial()) {
    on<SaveUserResultEvent>(_onSaveUserResult);
    on<FetchUserResultEvent>(_onFetchUserResult);
  }

  Future<void> _onSaveUserResult(
      SaveUserResultEvent event, Emitter<UserResultState> emit) async {
    emit(InProgress());
    try {
      await userResultRepository.saveUserResult(
          event.courseId, event.userResult);
      emit(UserResultSaved());
      await Future.delayed(
        Duration(seconds: 3),
      );
      emit(UserResultInitial());
    } catch (e) {
      emit(UserResultError(e.toString()));
    }
  }

  Future<void> _onFetchUserResult(
      FetchUserResultEvent event, Emitter<UserResultState> emit) async {
    emit(InProgress());
    try {
      // UserResult? userResult = await userResultRepository.getUserResult(
      //     event.courseId, event.userId);
      List<UserResult?> userResult = await userResultRepository.getUserResult(
          event.courseId, event.userId);
      if (userResult != null) {
        emit(UserResultLoaded(userResult));
      } else {
        emit(UserResultError('Результаты не найдены'));
      }
    } catch (e) {
      emit(UserResultError(e.toString()));
    }
  }
}
