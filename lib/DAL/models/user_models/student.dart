import 'user.dart';

class Student extends UserModel {
  List<dynamic> subscribedCourses;

  Student(
      {required super.uid,
      required super.email,
      required this.subscribedCourses});
}
