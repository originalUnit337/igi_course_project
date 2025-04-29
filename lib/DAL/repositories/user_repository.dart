import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igi_course_project/DAL/models/user_models/admin.dart';
import 'package:igi_course_project/DAL/models/user_models/student.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/DAL/models/user_models/user.dart';

class UserRepository {
  final FirebaseFirestore firestore;

  UserRepository(this.firestore);

  Future<List<UserModel?>> fetchUsers() async {
    try {
      CollectionReference users = firestore.collection('users');
      QuerySnapshot snapshot = await users.get();
      return snapshot.docs.map((doc) {
        String role = doc['role'];
        switch (role) {
          case 'admin':
            return Admin(
              uid: doc.id,
              email: doc['email'],
              isBlocked: doc['isBlocked'],
            );
          case 'teacher':
            final data = doc.data() as Map<String, dynamic>;
            final coursesIdList = (data.containsKey('courses_id') &&
                    data['courses_id'] is List<dynamic>)
                ? (data['courses_id'] as List<dynamic>)
                    .map((e) => e as int)
                    .toList()
                : [0];
            return Teacher(
              uid: doc.id,
              email: doc['email'],
              createdCourses: coursesIdList,
              isBlocked: doc['isBlocked'],
            );
          case 'student':
            final data = doc.data() as Map<String, dynamic>;
            final subcribedCourses = (data.containsKey('subcribedCourses') &&
                    data['subcribedCourses'] is List<dynamic>)
                ? (data['subcribedCourses'] as List<dynamic>)
                    .map((e) => e as int)
                    .toList()
                : [0];
            return Student(
              uid: doc.id,
              email: doc['email'],
              subscribedCourses: subcribedCourses,
              isBlocked: doc['isBlocked'],
            );
          default:
            return null;
        }
      }).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<void> blocUser(UserModel user, bool isBlocked) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'isBlocked': isBlocked});
    } on Exception {
      rethrow;
    }
  }
}
