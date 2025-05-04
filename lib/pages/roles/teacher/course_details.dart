import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/course.dart';
import 'package:igi_course_project/DAL/models/lesson/lesson.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/bloc/course/course_event.dart';
import 'package:igi_course_project/bloc/user_result/user_result_bloc.dart';
import 'package:igi_course_project/bloc/user_result/user_result_event.dart';
import 'package:igi_course_project/bloc/user_result/user_result_state.dart';

class CourseDetails extends StatelessWidget {
  final Course course;

  const CourseDetails({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(course.title),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Уроки'),
              Tab(text: 'Непроверенные результаты работы студентов на курсе'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            AssignmentsList(course: course),
            StudentResultsList(course: course),
          ],
        ),
      ),
    );
  }
}

class AssignmentsList extends StatefulWidget {
  final Course course;

  const AssignmentsList({super.key, required this.course});

  @override
  State<AssignmentsList> createState() => _AssignmentsListState();
}

class _AssignmentsListState extends State<AssignmentsList> {
  late TextEditingController _courseTitleController;
  late TextEditingController _courseDescriptionController;
  late TextEditingController _courseLanguageController;
  @override
  void initState() {
    super.initState();
    // Инициализируем контроллеры с текущими значениями курса
    _courseTitleController = TextEditingController(text: widget.course.title);
    _courseDescriptionController =
        TextEditingController(text: widget.course.description);
    _courseLanguageController =
        TextEditingController(text: widget.course.language);
  }

  @override
  void dispose() {
    // Освобождаем контроллеры при уничтожении виджета
    _courseTitleController.dispose();
    _courseDescriptionController.dispose();
    _courseLanguageController.dispose();
    super.dispose();
  }

  void _updateCourseDetails() {
    setState(() {
      widget.course.title = _courseTitleController.text;
      widget.course.description = _courseDescriptionController.text;
      widget.course.language = _courseLanguageController.text;
    });
  }

  void _addNewLesson() {
    // Логика для добавления нового урока
    setState(() {
      widget.course.lessons.add(Lesson.empty());
    });
  }

  void _removeLesson(Lesson lesson) {
    setState(() {
      widget.course.lessons.remove(lesson);
    });
  }

  @override
  Widget build(BuildContext context) {
    void _saveCourseDetails(Course course) {
      BlocProvider.of<CourseBloc>(context).add(UpdateCourseEvent(course));
    }

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _saveCourseDetails(widget.course),
        tooltip: 'Сохранить изменения',
        child: Icon(Icons.save),
      ), // appBar: AppBar(
      //   title: Text('Редактировать ${widget.course.name}'),
      // ),
      body: ListView(
        children: [
          // Поля для редактирования названия, описания и языка курса
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _courseTitleController,
                  decoration: InputDecoration(labelText: 'Название курса'),
                  onChanged: (value) => _updateCourseDetails(),
                ),
                TextField(
                  controller: _courseDescriptionController,
                  decoration: InputDecoration(labelText: 'Описание курса'),
                  onChanged: (value) => _updateCourseDetails(),
                ),
                TextField(
                  controller: _courseLanguageController,
                  decoration: InputDecoration(labelText: 'Язык курса'),
                  onChanged: (value) => _updateCourseDetails(),
                ),
              ],
            ),
          ),
          // Список уроков
          Text(
            'Уроки',
            style: Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          ...widget.course.lessons.map((lesson) {
            return ListTile(
              title: Text(lesson.title),
              subtitle: Text(lesson.description),
              trailing: IconButton(
                icon: Icon(Icons.delete),
                onPressed: () => _removeLesson(lesson),
              ),
              onTap: () {
                // Логика для перехода к деталям урока
                Navigator.pushNamed(
                  context,
                  '/lessonDetails',
                  arguments: {
                    'course': widget.course,
                    'lesson': lesson,
                  },
                );
              },
            );
          }).toList(),
          ElevatedButton(
            onPressed: _addNewLesson,
            child: Text('Добавить новый урок'),
          ),
        ],
      ),
    );
  }
}

class StudentResultsList extends StatefulWidget {
  final Course course;
  const StudentResultsList({super.key, required this.course});

  @override
  State<StudentResultsList> createState() => _StudentResultsListState();
}

class _StudentResultsListState extends State<StudentResultsList> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<UserResultBloc>(context)
        .add(FetchAllUsersCourseResults(widget.course.documentId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserResultBloc, UserResultState>(
        builder: (context, state) {
      switch (state) {
        case UserResultError _:
          return Center(
            child: Text(state.message),
          );
        case InProgress _:
          return CircularProgressIndicator();
        case UserResultLoaded _:
          if (state.userResult.isEmpty)
            return Center(
              child: Text('Empty :('),
            );
          return ListView.builder(
            itemCount: state.userResult.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text(state.userResult[index]!.lessonName),
                  subtitle: Text(state.userResult[index]!.score.toString()),
                  onTap: () {
                    Navigator.pushNamed(context, '/teacherResultPage',
                        arguments: {
                          'userId': state.userResult[index]!.userId,
                          'course': widget.course,
                          'lesson': widget.course.lessons.firstWhere((lesson) =>
                              lesson.title ==
                              state.userResult[index]!.lessonName),
                          'userResult': state.userResult[index],
                        });
                  },
                ),
              );
            },
          );
        default:
          return Center(
            child: Text('nothing to show'),
          );
      }
    });
  }
}
