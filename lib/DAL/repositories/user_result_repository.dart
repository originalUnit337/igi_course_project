// user_result_repository.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igi_course_project/DAL/models/user_result/user_result.dart';

class UserResultRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> saveUserResult(String courseId, UserResult userResult) async {
    // await _firestore
    //     .collection('Courses')
    //     .doc(courseId)
    //     .collection('Lessons')
    //     .doc(lessonId)
    //     .collection('userResults')
    //     .doc(userResult.userId)
    //     .set(userResult.toJson());
    // await _firestore.collection('Courses').doc(courseId).collection('userResults')
    // .doc(userResult.userId)
    // .set(userResult.toJson());
    String documentId =
        '${userResult.userId}_${courseId}_${userResult.lessonName}';
    await _firestore
        .collection('userResults')
        .doc(documentId)
        .set(userResult.toJson());
    //await _firestore.collection('userResults').add(userResult.toJson());
    // .add(userResult
    //     .toJson()); // Используем add для создания нового документа
  }

  Future<List<UserResult>> getUserResults(
      String courseId, String lessonId) async {
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
    // QuerySnapshot querySnapshot = await _firestore
    //     .collection('Courses')
    //     .doc(courseId)
    //     .collection('Lessons')
    //     .doc(lessonId)
    //     .collection('userResults')
    //     .get();

    // return querySnapshot.docs.map((doc) {
    //   return UserResult.fromJson(doc.data() as Map<String, dynamic>);
    // }).toList();
    CollectionReference results = _firestore.collection('userResults');
    QuerySnapshot querySnapshot = await results
        .where('courseId', isEqualTo: courseId)
        .where('lessonId', isEqualTo: lessonId)
        .get();
    return querySnapshot.docs.map((doc) {
      return UserResult.fromJson(doc.data() as Map<String, dynamic>);
    }).toList();
  }

  Future<UserResult?> getUserResult(
      String courseId, String lessonId, String userId) async {
    // Получаем результаты для конкретного пользователя по его userId
    DocumentSnapshot doc = await _firestore
        .collection('Courses')
        .doc(courseId)
        .collection('Lessons')
        .doc(lessonId)
        .collection('userResults')
        .doc(userId) // Получаем результаты для конкретного пользователя
        .get();

    if (doc.exists) {
      return UserResult.fromJson(doc.data() as Map<String, dynamic>);
    }
    return null; // Если документа нет, возвращаем null
  }
}
