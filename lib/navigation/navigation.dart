import 'package:flutter/material.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/pages/course/course_page.dart';
import 'package:igi_course_project/pages/roles/teacher/course_details.dart';
import 'package:igi_course_project/pages/roles/teacher/lesson_details.dart';

import '../pages/authorization/login_page.dart';
import '../pages/authorization/registration_page.dart';
import '../pages/course/preview_course_page.dart';
import '../pages/home_page.dart';

class AppNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => HomePage());
      case '/previewCoursePage':
        final Course course = settings.arguments as Course;
        return MaterialPageRoute(
          builder: (context) => PreviewCoursePage(
            course: course,
          ),
        );
      case '/coursePage':
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        final String userId = args['userId'];
        final Course course = args['course'];
        return MaterialPageRoute(
          builder: (context) => CoursePage(
            userId: userId,
            course: course,
          ),
        );
      case '/courseDetails':
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        //final String userId = args['userId'];
        final Course course = args['course'];
        return MaterialPageRoute(
          builder: (context) => CourseDetails(
            course: course,
          ),
        );
      case '/lessonDetails':
        final Map<String, dynamic> args =
            settings.arguments as Map<String, dynamic>;
        final Course course = args['course'];
        final Lesson lesson = args['lesson'];
        return MaterialPageRoute(
          builder: (context) => LessonDetails(
            course: course,
            lesson: lesson,
          ),
        );
      case '/loginPage':
        return MaterialPageRoute(builder: (context) => LoginPage());
      case '/registrationPage':
        return MaterialPageRoute(builder: (context) => RegistrationPage());
      default:
        return MaterialPageRoute(builder: (context) => HomePage());
    }
  }
}
