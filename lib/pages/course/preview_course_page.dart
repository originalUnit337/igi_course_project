import 'package:flutter/material.dart';

import '../../DAL/models/course/course.dart';

class PreviewCoursePage extends StatelessWidget {
  final Course course;
  const PreviewCoursePage({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Preview: ${course.name}'),
      ),
      body: Center(
        child: Column(
          children: [
            Text(
              course.name,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            Text(course.description,
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}
