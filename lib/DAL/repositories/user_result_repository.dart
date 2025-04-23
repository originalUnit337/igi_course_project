// user_result_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';

class UserResultRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserResult(String courseId, UserResult userResult) async {
    await _firestore
        .collection('Courses')
        .doc(courseId)
        .collection('userResults')
        //.doc(userResult.userId)
        //.set(userResult.toJson());
        .add(userResult
            .toJson()); // Используем add для создания нового документа
  }

  Future<List<UserResult>> getUserResult(String courseId) async {
    // DocumentSnapshot doc = await _firestore
    //     .collection('courses')
    //     .doc(courseId)
    //     .collection('userResults')
    //     .doc(userId)
    //     .get();

    // if (doc.exists) {
    //   return UserResult.fromJson(doc.data() as Map<String, dynamic>);
    // }
    // return null;
    QuerySnapshot querySnapshot = await _firestore
        .collection('Courses')
        .doc(courseId)
        .collection('userResults')
        //.where('userId', isEqualTo: userId) // Фильтруем результаты по userId
        .get();

    return querySnapshot.docs.map((doc) {
      return UserResult.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
