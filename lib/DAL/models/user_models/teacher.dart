import 'user.dart';

class Teacher extends UserModel {
  List<dynamic> createdCourses;

  Teacher(
      {required super.uid,
      required super.email,
      required this.createdCourses,
      super.isBlocked = false});
}
