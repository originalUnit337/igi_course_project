import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';

class CourseRepository {
  final FirebaseFirestore firestore;

  CourseRepository(this.firestore);

  Future<void> addCourse(Course course, Teacher currentTeacher) async {
    CollectionReference courses = firestore.collection('Courses');
    DocumentReference newCourseRef = await courses.add(course.toJson());
    await FirebaseFirestore.instance
        .collection('users')
        .doc(currentTeacher.uid)
        .update({
      'createdCourses': FieldValue.arrayUnion([newCourseRef])
    });
  }

  Future<List<Course>> fetchCourses() async {
    try {
      CollectionReference courses = firestore.collection('Courses');
      QuerySnapshot snapshot = await courses.get();

      List<Course> courseList =
          await Future.wait(snapshot.docs.map((doc) async {
        String documentId = doc.id;

        Course course =
            Course.fromJson(doc.data() as Map<String, dynamic>, id: documentId);

        return course;
      }).toList());

      return courseList;
    } on Exception {
      rethrow;
    }
  }

  Future<List<Lesson>> fetchLessons(String courseId) async {
    try {
      CollectionReference lessonsRef =
          firestore.collection('Courses').doc(courseId).collection('Lessons');
      QuerySnapshot snapshot = await lessonsRef.get();
      return snapshot.docs.map((doc) {
        String documentId = doc.id;
        return Lesson.fromJson(doc.data() as Map<String, dynamic>,
            id: documentId);
      }).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<void> subscribeToCourse(String userId, String courseId) async {
    DocumentReference courseRef =
        FirebaseFirestore.instance.collection('Courses').doc(courseId);

    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentSnapshot courseSnapshot = await transaction.get(courseRef);
      Map<String, dynamic>? courseData =
          courseSnapshot.data() as Map<String, dynamic>?;
      int currentPopularity = courseData?['popularity'] ?? 0;
      int newPopularity = currentPopularity + 1;
      transaction.update(courseRef, {'popularity': newPopularity});

      transaction
          .update(FirebaseFirestore.instance.collection('users').doc(userId), {
        'subscribedCourses': FieldValue.arrayUnion([courseRef]),
      });
    });
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      DocumentReference courseRef =
          FirebaseFirestore.instance.collection('Courses').doc(courseId);

      QuerySnapshot teachersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('subscribedCourses', arrayContains: courseRef)
          .get();

      for (var teacherDoc in teachersSnapshot.docs) {
        await teacherDoc.reference.update({
          'subscribedCourses': FieldValue.arrayRemove([courseRef])
        });
      }

      QuerySnapshot creatorsSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('createdCourses', arrayContains: courseRef)
          .get();

      for (var creatorDoc in creatorsSnapshot.docs) {
        await creatorDoc.reference.update({
          'createdCourses': FieldValue.arrayRemove([courseRef])
        });
      }
      await _deleteLessons(courseRef);
      await courseRef.delete();
      print('Курс и ссылки на него у учителей успешно удалены.');
    } on Exception {
      rethrow;
    }
  }

  Future<void> _deleteLessons(DocumentReference courseRef) async {
    CollectionReference lessonsRef = courseRef.collection('Lessons');
    QuerySnapshot lessonsSnapshot = await lessonsRef.get();

    for (var lessonDoc in lessonsSnapshot.docs) {
      await lessonDoc.reference.delete();
    }
  }

  Future<void> updateCourse(Course course) async {
    CollectionReference courses =
        FirebaseFirestore.instance.collection('Courses');
    try {
      await courses.doc(course.documentId).update(course.toJson());
    } on Exception catch (e) {
      print('Error updating course: $e');
      rethrow;
    }
  }

  Future<void> updateLesson(
      String courseId, String lessonId, Lesson lesson) async {
    CollectionReference courses =
        FirebaseFirestore.instance.collection('Courses');
    try {
      DocumentReference lessonRef = FirebaseFirestore.instance
          .collection('Courses')
          .doc(courseId)
          .collection('Lessons')
          .doc(lessonId);
      await lessonRef.update(lesson.toJson());
    } on Exception {
      rethrow;
    }
  }
}
