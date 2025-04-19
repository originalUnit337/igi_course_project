import 'user.dart';

class Student extends UserModel {
  List<int> coursesId;

  Student({required super.uid, required super.email, required this.coursesId});
}
