import 'package:flutter/material.dart';

import '../DAL/models/course/course.dart';
import '../pages/authorization/login_page.dart';
import '../pages/authorization/registration_page.dart';
import '../pages/course/preview_course_page.dart';
import '../pages/home_page.dart';

class AppNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (context) => const HomePage());
      case '/previewCoursePage':
        final Course course = settings.arguments as Course;
        return MaterialPageRoute(
          builder: (context) => PreviewCoursePage(
            course: course,
          ),
        );
      case '/loginPage':
        return MaterialPageRoute(builder: (context) => LoginPage());
      case '/registrationPage':
        return MaterialPageRoute(builder: (context) => RegistrationPage());
      default:
        return MaterialPageRoute(builder: (context) => const HomePage());
    }
  }
}
