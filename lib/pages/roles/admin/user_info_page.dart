import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:igi_course_project/DAL/models/user_models/admin.dart';
import 'package:igi_course_project/DAL/models/user_models/student.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/DAL/models/user_models/user.dart';
import 'package:igi_course_project/bloc/user/user_bloc.dart';
import 'package:igi_course_project/bloc/user/user_event.dart';

class UserInfoPage extends StatefulWidget {
  final UserModel user;

  UserInfoPage({super.key, required this.user});

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Информация о пользователе ID: ${widget.user.uid} | Email: ${widget.user.email}'),
      ),
      body: _buildUserInfo(context, widget.user),
    );
  }

  Widget _buildUserInfo(BuildContext context, UserModel user) {
    return Column(
      children: [
        _userDetails(user),
        _blockUserSwitch(context, user),
      ],
    );
  }

  Widget _userDetails(UserModel user) {
    switch (user.runtimeType) {
      case Teacher:
        Teacher teacher = user as Teacher;
        return Column(
          children: [
            Text('Роль: Учитель'),
            Text('UID: ${teacher.uid}'),
            Text('Почта: ${teacher.email}'),
            Text('Созданные курсы: ${teacher.createdCourses.length}'),
          ],
        );
      case Student:
        Student student = user as Student;
        return Column(
          children: [
            Text('Роль: Студент'),
            Text('UID: ${student.uid}'),
            Text('Почта: ${student.email}'),
            Text(
                'Курсы, на которые подписан: ${student.subscribedCourses.length}'),
          ],
        );
      case Admin:
        Admin admin = user as Admin;
        return Column(
          children: [
            Text('Роль: Администратор'),
            Text('UID: ${admin.uid}'),
            Text('Почта: ${admin.email}'),
          ],
        );
      default:
        return Text('Неизвестная роль');
    }
  }

  Widget _blockUserSwitch(BuildContext context, UserModel user) {
    return SwitchListTile(
      title: Text('Заблокировать пользователя'),
      value: user.isBlocked,
      onChanged: (bool value) {
        // Здесь вы можете добавить логику для блокировки/разблокировки пользователя
        _toggleUserBlockStatus(user, value);
        setState(() {
          user.isBlocked = value;
        });
        BlocProvider.of<UserBloc>(context).add(BlockUserEvent(user, value));
      },
    );
  }

  void _toggleUserBlockStatus(UserModel user, bool isBlocked) {
    // Здесь вы можете добавить код для обновления статуса блокировки в вашей базе данных
    // Например, вызов функции для обновления Firestore
    // Например:
    // await FirebaseFirestore.instance.collection('users').doc(user.uid).update({'isBlocked': isBlocked});

    // Для демонстрации просто выведем в консоль
    print(
        'Пользователь ${user.uid} ${isBlocked ? 'заблокирован' : 'разблокирован'}');
  }
}
