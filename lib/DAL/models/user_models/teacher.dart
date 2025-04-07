import 'user.dart';

class Teacher extends UserModel {
  List<int> coursesId;

  Teacher({required super.uid, required super.email, required this.coursesId});
}
