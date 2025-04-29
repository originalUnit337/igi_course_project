import 'package:igi_course_project/DAL/models/user_models/user.dart';

abstract class UserEvent {}

class FetchUserEvent extends UserEvent {}

class BlockUserEvent extends UserEvent {
  final UserModel user;
  final bool isBlocked;

  BlockUserEvent(this.user, this.isBlocked);
}
