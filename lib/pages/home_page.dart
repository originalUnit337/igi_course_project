import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/course/audition_exercise.dart';
import 'package:igi_course_project/DAL/models/course/reading_exercise.dart';
import 'package:igi_course_project/DAL/models/user_models/admin.dart';
import 'package:igi_course_project/DAL/models/user_models/student.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/DAL/models/user_models/user.dart';
import 'package:igi_course_project/bloc/authentication/authentication_bloc.dart';
import 'package:igi_course_project/bloc/authentication/authentication_event.dart';
import 'package:igi_course_project/bloc/authentication/authentication_state.dart';
import 'package:igi_course_project/pages/roles/admin/admin_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../DAL/models/course/course.dart';
import '../DAL/models/course/grammar_exercise.dart';
import '../DAL/models/course/question.dart';
import '../bloc/course/course_bloc.dart';
import '../bloc/course/course_event.dart';
import '../bloc/course/course_state.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});
  UserModel? currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Polyglot Path'),
        centerTitle: true,
        actions: [
          BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
            if (state is AuthSignedIn || state is AuthSignedUp) {
              currentUser = (state as AuthSignedIn).userModel;
              return TextButton.icon(
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(AuthSignOutEvent());
                },
                label: Text(currentUser!.email),
                icon: Icon(Icons.logout),
              );
            } else {
              return Row(
                children: [
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/loginPage');
                    },
                    label: Text('Login'),
                    icon: Icon(Icons.login),
                  ),
                  SizedBox(width: 20),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pushNamed(context, '/registrationPage');
                    },
                    label: Text('Register'),
                    icon: Icon(Icons.person_add),
                  ),
                ],
              );
            }
          }),
        ],
      ),
      body: BlocBuilder<AuthBloc, AuthState>(builder: (context, authState) {
        UserModel? currentUser;
        if (authState is AuthSignedIn || authState is AuthSignedUp) {
          currentUser = (authState as AuthSignedIn).userModel;
        }

        return BlocBuilder<CourseBloc, CourseState>(
            builder: (context, courseState) {
          if (currentUser is Admin) {
            return AdminPage();
            //return Center(child: Text('ADMIN'));
          } else if (currentUser is Teacher) {
            return Center(child: Text('TEACHER'));
          } else if (currentUser is Teacher) {
            return Center(child: Text('STUDENT'));
          } else {
            switch (courseState) {
              case CourseLoading _:
                return Center(child: CircularProgressIndicator());
              case CourseLoaded _:
                return ListView.builder(
                  itemCount: courseState.courses.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                      child: ListTile(
                        leading: SizedBox(
                          width: 100,
                          height: 70,
                          child: Placeholder(),
                        ),
                        title: Text(courseState.courses[index].name),
                        subtitle: Text(courseState.courses[index].description),
                        onTap: () {
                          Navigator.pushNamed(context, '/previewCoursePage',
                              arguments: courseState.courses[index]);
                        },
                      ),
                    );
                  },
                );
              case CourseError _:
                return Center(child: Text('Error: ${courseState.message}'));
              default:
                return Center(child: Text('No courses available.'));
            }
          }
        });
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => {
          //GetIt.I<CourseBloc>().add(FetchCourseEvent()),
          //BlocProvider.of<CourseBloc>(context).add(FetchCourseEvent()),
          addCourseOGO()
        },
      ),
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

addCourseOGO() async {
  List<Question> grammarQuestions = [
    Question(
      task: "She ___ (to be) a doctor.",
      options: ["is", "are", "was", "were"],
      answer: "is",
    ),
    Question(
      task: "What is the past tense of 'go'?",
      options: ["goes", "went", "going", "gone"],
      answer: "went",
    ),
  ];

  // Создание грамматического упражнения
  GrammarExercise grammarExercise = GrammarExercise(
    type: "Fill in the blanks",
    questions: grammarQuestions,
  );

  // Создание вопросов для чтения
  List<Question> readingQuestions = [
    Question(
      task: "What was the main idea of the passage?",
      options: [
        "A story about a knight",
        "A recipe",
        "A travel guide",
        "A history lesson"
      ],
      answer: "A story about a knight",
    ),
    Question(
      task: "Where does the sun rise?",
      options: ["In the west", "In the east", "In the north", "In the south"],
      answer: "In the east",
    ),
  ];

  // Создание упражнения на чтение
  ReadingExercise readingExercise = ReadingExercise(
    type: "Comprehension",
    questions: readingQuestions,
  );

  // Создание вопросов для аудиоупражнений
  List<Question> auditionQuestions = [
    Question(
      task: "What did you hear?",
      options: ["A bell", "A dog barking", "A car honking", "A person talking"],
      answer: "A bell",
    ),
    Question(
      task: "What was the main topic of the audio?",
      options: ["Travel", "Food", "Sports", "Music"],
      answer: "Travel",
    ),
  ];

  // Создание аудиоупражнения
  AuditionExercise auditionExercise = AuditionExercise(
    type: "Listening comprehension",
    questions: auditionQuestions,
  );

  Course course = Course(
    documentId: "1", // Пример ID документа
    name: "English Language Course",
    description: "A comprehensive course for learning English.",
    language: "English",
    grammarExercises: [grammarExercise],
    readingExercises: [readingExercise],
    auditionExercises: [auditionExercise],
  );

  await addCourse(course);

  grammarQuestions = [
    Question(
      task: "They ___ (to have) a great time.",
      options: ["has", "have", "had", "having"],
      answer: "have",
    ),
    Question(
      task: "He ___ (to go) to the store yesterday.",
      options: ["go", "goes", "went", "gone"],
      answer: "went",
    ),
  ];

  grammarExercise = GrammarExercise(
    type: "Fill in the blanks",
    questions: grammarQuestions,
  );

  readingQuestions = [
    Question(
      task: "What is the setting of the story?",
      options: ["A forest", "A city", "A beach", "A mountain"],
      answer: "A forest",
    ),
  ];

  readingExercise = ReadingExercise(
    type: "Comprehension",
    questions: readingQuestions,
  );

  auditionQuestions = [
    Question(
      task: "What sound did you hear?",
      options: [
        "A train",
        "A cat meowing",
        "A phone ringing",
        "A child laughing"
      ],
      answer: "A phone ringing",
    ),
  ];

  auditionExercise = AuditionExercise(
    type: "Listening comprehension",
    questions: auditionQuestions,
  );

  course = Course(
    documentId: "2",
    name: "English Language Course 1",
    description: "A comprehensive course for learning English.",
    language: "English",
    grammarExercises: [grammarExercise],
    readingExercises: [readingExercise],
    auditionExercises: [auditionExercise],
  );

  await addCourse(course);

  grammarQuestions = [
    Question(
      task: "We ___ (to be) happy.",
      options: ["is", "are", "was", "were"],
      answer: "are",
    ),
    Question(
      task: "She ___ (to read) a book now.",
      options: ["reads", "read", "reading", "readed"],
      answer: "reads",
    ),
    Question(
      task: "I ___ (to see) that movie last week.",
      options: ["see", "saw", "seen", "seeing"],
      answer: "saw",
    ),
  ];

  grammarExercise = GrammarExercise(
    type: "Fill in the blanks",
    questions: grammarQuestions,
  );

  readingQuestions = [
    Question(
      task: "What genre is the text?",
      options: ["Fiction", "Non-fiction", "Poetry", "Drama"],
      answer: "Fiction",
    ),
    Question(
      task: "Who is the main character?",
      options: ["A wizard", "A princess", "A dragon", "A knight"],
      answer: "A wizard",
    ),
  ];

  readingExercise = ReadingExercise(
    type: "Comprehension",
    questions: readingQuestions,
  );

  auditionQuestions = [
    Question(
      task: "What did you hear in the background?",
      options: [
        "Birds chirping",
        "Traffic noise",
        "Music playing",
        "People talking"
      ],
      answer: "Music playing",
    ),
  ];

  auditionExercise = AuditionExercise(
    type: "Listening comprehension",
    questions: auditionQuestions,
  );

  course = Course(
    documentId: "3",
    name: "English Language Course 2",
    description: "A comprehensive course for learning English.",
    language: "English",
    grammarExercises: [grammarExercise],
    readingExercises: [readingExercise],
    auditionExercises: [auditionExercise],
  );

  await addCourse(course);

  grammarQuestions = [
    Question(
      task: "You ___ (to be) my best friend.",
      options: ["is", "are", "was", "were"],
      answer: "are",
    ),
  ];

  grammarExercise = GrammarExercise(
    type: "Fill in the blanks",
    questions: grammarQuestions,
  );

  readingQuestions = [
    Question(
      task: "What is the author's purpose?",
      options: ["To inform", "To entertain", "To persuade", "To describe"],
      answer: "To inform",
    ),
  ];

  readingExercise =
      ReadingExercise(type: "Comprehension", questions: readingQuestions);

  auditionQuestions = [
    Question(
      task: "What type of music did you hear?",
      options: ["Classical", "Rock", "Jazz", "Pop"],
      answer: "Jazz",
    ),
    Question(
      task: "How many instruments were playing?",
      options: ["One", "Two", "Three", "Four"],
      answer: "Three",
    ),
  ];

  auditionExercise = AuditionExercise(
    type: "Listening comprehension",
    questions: auditionQuestions,
  );

  course = Course(
    documentId: "4",
    name: "English Language Course 3",
    description: "A comprehensive course for learning English.",
    language: "English",
    grammarExercises: [grammarExercise],
    readingExercises: [readingExercise],
    auditionExercises: [auditionExercise],
  );

  await addCourse(course);

  grammarQuestions = [
    Question(
      task: "I ___ (to like) ice cream.",
      options: ["like", "likes", "liked", "liking"],
      answer: "like",
    ),
    Question(
      task: "They ___ (to play) soccer every weekend.",
      options: ["play", "plays", "played", "playing"],
      answer: "play",
    ),
  ];

  grammarExercise = GrammarExercise(
    type: "Fill in the blanks",
    questions: grammarQuestions,
  );

  readingQuestions = [
    Question(
      task: "What is the main theme of the article?",
      options: ["Health", "Technology", "Environment", "Education"],
      answer: "Health",
    ),
    Question(
      task: "What solution is proposed?",
      options: ["Exercise more", "Eat less", "Sleep more", "Drink water"],
      answer: "Exercise more",
    ),
  ];

  readingExercise = ReadingExercise(
    type: "Comprehension",
    questions: readingQuestions,
  );

  auditionQuestions = [
    Question(
      task: "What did you hear?",
      options: ["A thunderstorm", "A train", "A dog barking", "A baby crying"],
      answer: "A thunderstorm",
    ),
  ];

  auditionExercise = AuditionExercise(
    type: "Listening comprehension",
    questions: auditionQuestions,
  );

  course = Course(
    documentId: "5",
    name: "English Language Course 4",
    description: "A comprehensive course for learning English.",
    language: "English",
    grammarExercises: [grammarExercise],
    readingExercises: [readingExercise],
    auditionExercises: [auditionExercise],
  );

  await addCourse(course);

  grammarQuestions = [
    Question(
      task: "He ___ (to eat) breakfast at 8 AM.",
      options: ["eat", "eats", "eated", "eating"],
      answer: "eats",
    ),
    Question(
      task: "We ___ (to go) to the park last Sunday.",
      options: ["go", "went", "gone", "going"],
      answer: "went",
    ),
  ];

  grammarExercise = GrammarExercise(
    type: "Fill in the blanks",
    questions: grammarQuestions,
  );

  readingQuestions = [
    Question(
      task: "What is the conclusion of the passage?",
      options: [
        "It was a great day.",
        "The weather was bad.",
        "Everyone had fun.",
        "They went home."
      ],
      answer: "Everyone had fun.",
    ),
  ];

  readingExercise = ReadingExercise(
    type: "Comprehension",
    questions: readingQuestions,
  );

  auditionQuestions = [
    Question(
      task: "What was the main topic of the audio?",
      options: ["Nature", "History", "Science", "Art"],
      answer: "Nature",
    ),
    Question(
      task: "What animal did you hear?",
      options: ["A lion", "A bird", "A whale", "A frog"],
      answer: "A bird",
    ),
  ];

  auditionExercise = AuditionExercise(
    type: "Listening comprehension",
    questions: auditionQuestions,
  );

  course = Course(
    documentId: "6",
    name: "English Language Course 5",
    description: "A comprehensive course for learning English.",
    language: "English",
    grammarExercises: [grammarExercise],
    readingExercises: [readingExercise],
    auditionExercises: [auditionExercise],
  );

  await addCourse(course);
}
