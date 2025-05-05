// user_result_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';

class UserResultRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserResult(String courseId, UserResult userResult) async {
    String documentId =
        '${userResult.userId}_${courseId}_${userResult.lessonName}';
    await _firestore
        .collection('userResults')
        .doc(documentId)
        .set(userResult.toJson())
        .timeout(
          const Duration(
            seconds: 10,
          ),
        );
  }

  Future<List<UserResult>> getUserResults(
      String courseId, String lessonId) async {
    CollectionReference results = _firestore.collection('userResults');
    QuerySnapshot querySnapshot = await results
        .where('courseId', isEqualTo: courseId)
        .where('lessonId', isEqualTo: lessonId)
        .get();

    return querySnapshot.docs.map((doc) {
      return UserResult.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<List<UserResult>> getUserLessonsResults(
      String userId, String courseId) async {
    CollectionReference results = _firestore.collection('userResults');
    QuerySnapshot querySnapshot = await results
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .get();

    return querySnapshot.docs.map((doc) {
      return UserResult.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<UserResult?> getUserResult(
      String courseId, String lessonId, String userId) async {
    CollectionReference results = _firestore.collection('userResults');
    QuerySnapshot querySnapshot = await results
        .where('userId', isEqualTo: userId)
        .where('courseId', isEqualTo: courseId)
        .where('lessonName', isEqualTo: lessonId)
        .get();
    if (querySnapshot.docs.isNotEmpty) {
      return UserResult.fromJson(
          querySnapshot.docs.first as Map<String, dynamic>);
    } else {
      return null;
    }
  }

  Future<List<UserResult>> getAllUserCourseResults(String courseId) async {
    CollectionReference results = _firestore.collection('userResults');
    QuerySnapshot querySnapshot = await results
        .where('courseId', isEqualTo: courseId)
        .where('isChecked', isEqualTo: false)
        .get();

    return querySnapshot.docs.map((doc) {
      return UserResult.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }
}
