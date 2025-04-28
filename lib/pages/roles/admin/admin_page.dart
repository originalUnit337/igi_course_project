import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/bloc/course/course_bloc.dart';
import 'package:igi_course_project/bloc/course/course_event.dart';
import 'package:igi_course_project/bloc/course/course_state.dart';
import 'package:igi_course_project/bloc/user/user_bloc.dart';
import 'package:igi_course_project/bloc/user/user_state.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Admin Dashboard'),
          bottom: TabBar(
            tabs: [
              Tab(text: 'Пользователи'),
              Tab(text: 'Курсы'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            UserList(),
            CourseList(),
          ],
        ),
      ),
    );
  }
}

class UserList extends StatelessWidget {
  const UserList({super.key});

  @override
  Widget build(BuildContext context) {
    // Здесь вы можете использовать Bloc для получения списка пользователей
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          return ListView.builder(
            itemCount: state.users.length,
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
                  title: Text(state.users[index]!.email),
                ),
              );
            },
          );
        } else if (state is UserError) {
          return Center(
            child: Text(state.message),
          );
        } else {
          return Center(child: Text('Ошибка загрузки пользователей'));
        }
      },
    );
  }
}

class CourseList extends StatelessWidget {
  const CourseList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CourseBloc, CourseState>(
      builder: (context, state) {
        if (state is CourseLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is CourseLoaded) {
          return ListView.builder(
            itemCount: state.courses.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  leading:
                      Image.asset('course_img_${Random().nextInt(10) + 1}.png'),
                  title: Text(state.courses[index].title),
                  subtitle: Text(state.courses[index].description),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      BlocProvider.of<CourseBloc>(context).add(
                          DeleteCourseEvent(state.courses[index].documentId));
                    },
                  ),
                ),
              );
            },
          );
        } else {
          return Center(child: Text('Ошибка загрузки курсов'));
        }
      },
    );
  }
}
