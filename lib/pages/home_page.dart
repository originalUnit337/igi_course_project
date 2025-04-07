import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/main.dart';

import '../DAL/models/course/grammar_exercise.dart';
import '../DAL/models/course/question.dart';
import '../bloc/course/course_state.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Text('leading'),
        title: Text('ogo'),
        centerTitle: true,
        actions: [
          Icon(Icons.home),
          Icon(Icons.search),
          Icon(Icons.notifications),
          Icon(Icons.more_vert),
          Icon(Icons.dark_mode)
        ],
      ),
      body: BlocBuilder<CourseBloc, CourseState>(builder: (context, state) {
        switch (state) {
          case CourseLoading _:
            return Center(
              child: CircularProgressIndicator(),
            );
          case CourseLoaded _:
            ListView.builder(
                itemCount: state.courses.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(state.courses[index].language),
                  );
                });
          case CourseError _:
            return Center(
              child: Text('Error: ${state.message}'),
            );
          default:
            return Center(
              child: Text('No courses available.'),
            );
        }
        return Column(
          children: [
            SizedBox(
              height: 200,
              child: ElevatedButton(
                onPressed: () {
                  Course course = Course(
                    courseId: 1,
                    language: "English",
                    grammarExercises: [
                      GrammarExercise(
                        type: "fill_in_the_blanks",
                        questions: [
                          Question(
                            task: "She ___ to the gym every day.",
                            options: ["go", "goes", "gone", "going", "goed"],
                            answer: "goes",
                          ),
                        ],
                      ),
                    ],
                    readingExercises: [],
                    auditionExercises: [],
                  );
                  addCourse(course);
                },
                child: Text('TAP ME TO ADD COURSE'),
              ),
            ),
            // CarouselView(
            //   itemExtent: double.infinity,
            //   children: List<Widget>.generate(10, (int index) {
            //     return Center(child: Text('Item $index'));
            //   }),
            // ),
          ],
        );
      }),
    );
  }
}

Future<void> addCourse(Course course) async {
  try {
    CollectionReference courses =
        FirebaseFirestore.instance.collection('Courses');

    await courses.add(course.toJson());
    print('Course added successfully');
  } on Exception catch (e) {
    print(e.toString());
  }
}
