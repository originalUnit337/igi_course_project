import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';

class CourseRepository {
  final FirebaseFirestore firestore;

  CourseRepository(this.firestore);

  Future<void> addCourse(Course course) async {
    CollectionReference courses = firestore.collection('Courses');
    await courses.add(course.toJson());
  }

  Future<List<Course>> fetchCourses() async {
    CollectionReference courses = firestore.collection('Courses');
    QuerySnapshot snapshot = await courses.get();
    return snapshot.docs.map((doc) => 
    Course.fromJson(doc.data() as Map<String, dynamic>)).toList();
  }
}