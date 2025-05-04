abstract class UserModel {
  String uid;
  String email;
  bool isBlocked;

  UserModel({required this.uid, required this.email, required this.isBlocked});
}
