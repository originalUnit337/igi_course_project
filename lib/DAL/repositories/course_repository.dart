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
    CollectionReference lessonsRef = newCourseRef.collection('Lessons');
    for (var lesson in course.lessons) {
      await lessonsRef.add(lesson.toJson());
    }
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
      return snapshot.docs.map((doc) {
        String documentId = doc.id;
        return Course.fromJson(doc.data() as Map<String, dynamic>,
            id: documentId);
      }).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<List<Lesson>> fetchLessons(String courseId) async {
    try {
      CollectionReference lessonsRef = firestore.collection('Courses').doc(courseId).collection('Lessons');
      QuerySnapshot snapshot = await lessonsRef.get();
      return snapshot.docs.map((doc) {
        String documentId = doc.id;
        return Lesson.fromJson(doc.data() as Map<String, dynamic>, id: documentId);
      }).toList();
    } on Exception {
      rethrow;
    }
  }

  Future<void> subscribeToCourse(String userId, String courseId) async {
    DocumentReference courseRef =
        FirebaseFirestore.instance.collection('Courses').doc(courseId);

    await FirebaseFirestore.instance.collection('users').doc(userId).update({
      'subscribedCourses': FieldValue.arrayUnion([courseRef]),
    });
  }

  Future<void> deleteCourse(String courseId) async {
    try {
      DocumentReference courseRef =
          FirebaseFirestore.instance.collection('Courses').doc(courseId);

      QuerySnapshot teachersSnapshot = await FirebaseFirestore.instance
          .collection('users')
          //.where('role', isEqualTo: 'teacher')
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
    } on Exception {
      rethrow;
    }
  }
}
