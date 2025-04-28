import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/pages/roles/teacher/course_details.dart';

class CourseRepository {
  final FirebaseFirestore firestore;

  CourseRepository(this.firestore);

  Future<void> addCourse(Course course, Teacher currentTeacher) async {
    CollectionReference courses = firestore.collection('Courses');
    DocumentReference newCourseRef = await courses.add(course.toJson());
    // CollectionReference lessonsRef = newCourseRef.collection('Lessons');
    // for (var lesson in course.lessons) {
    //   await lessonsRef.add(lesson.toJson());
    // }
    // await newCourseRef.update({
    //   'lessons': FieldValue.delete(),
    // });
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

        // Получаем данные курса
        Course course =
            Course.fromJson(doc.data() as Map<String, dynamic>, id: documentId);

        // // Получаем уроки из подколлекции Lessons
        // QuerySnapshot lessonsSnapshot =
        //     await doc.reference.collection('Lessons').get();
        // List<Lesson> lessons = lessonsSnapshot.docs.map((lessonDoc) {
        //   return Lesson.fromJson(lessonDoc.data() as Map<String, dynamic>,
        //       id: lessonDoc.id);
        // }).toList();

        // Добавляем уроки в курс
        //course.lessons = lessons;

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
      // Обновляем сам документ курса
        await courses.doc(course.documentId).update(course.toJson());

      // Обновляем подколлекцию Lessons
      // CollectionReference lessonsRef =
      //     courses.doc(course.documentId).collection('Lessons');

      // Проходим по всем урокам и обновляем их
      // for (var lesson in course.lessons) {
      //   await lessonsRef.doc(lesson.documentId).update(lesson.toJson());
      // }
    } on Exception catch (e) {
      // Обработка ошибок
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
