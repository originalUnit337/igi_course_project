import 'user.dart';

class Student extends UserModel {
  List<Map<int, int>> coursesId;

  Student({required super.uid, required super.email, required this.coursesId});
}
