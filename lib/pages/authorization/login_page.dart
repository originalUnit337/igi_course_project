import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';

import '../../bloc/authentication/authentication_bloc.dart';
import '../../bloc/authentication/authentication_event.dart';
import '../../bloc/authentication/authentication_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: BlocProvider(
        create: (context) => GetIt.I<AuthBloc>(),
        child: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is AuthSignedIn) {
              Navigator.pushReplacementNamed(context, '/homePage');
            } else if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0), // Добавляем отступы
            child: Row(
              children: [
                Expanded(
                  child: Image.asset('login_img.png'),
                ),
                Expanded(
                  // child: Column(
                  //   mainAxisAlignment:
                  //       MainAxisAlignment.center, // Центрируем содержимое
                  //   children: [
                  //     Text(
                  //       'Please login to get access to bla-bla-bla',
                  //       style: TextStyle(fontSize: 18),
                  //       textAlign: TextAlign.center,
                  //     ),
                  //     SizedBox(
                  //         height: 20), // Отступ между текстом и полями ввода
                  //     TextField(
                  //       decoration: InputDecoration(
                  //         labelText: 'Email',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       keyboardType: TextInputType.emailAddress,
                  //     ),
                  //     SizedBox(height: 16), // Отступ между полями ввода
                  //     TextField(
                  //       decoration: InputDecoration(
                  //         labelText: 'Password',
                  //         border: OutlineInputBorder(),
                  //       ),
                  //       obscureText: true,
                  //     ),
                  //     SizedBox(
                  //         height: 20), // Отступ между полем ввода и кнопкой
                  //     ElevatedButton(
                  //       onPressed: () {
                  //         // Логика для входа
                  //       },
                  //       child: Text('Login'),
                  //     ),
                  //     SizedBox(
                  //         height: 20), // Отступ между кнопкой и разделителем
                  //     Divider(),
                  //     SizedBox(
                  //         height: 20), // Отступ между разделителем и текстом
                  //     Text('Or login with: '),
                  //     // Здесь можно добавить кнопки для других способов входа
                  //   ],
                  // ),
                  child: LoginForm(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center, // Центрируем содержимое
      children: [
        Text(
          'Please login to get access to bla-bla-bla',
          style: TextStyle(fontSize: 18),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: 20), // Отступ между текстом и полями ввода
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.emailAddress,
        ),
        SizedBox(height: 16), // Отступ между полями ввода
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 20), // Отступ между полем ввода и кнопкой
        ElevatedButton(
          onPressed: () {
            // Получаем значения email и password
            final email = _emailController.text;
            final password = _passwordController.text;

            // Добавляем событие для входа
            BlocProvider.of<AuthBloc>(context)
                .add(AuthSignInEvent(email: email, password: password));
          },
          child: Text('Login'),
        ),
        SizedBox(height: 20), // Отступ между кнопкой и разделителем
        Divider(),
        SizedBox(height: 20), // Отступ между разделителем и текстом
        Text('Or login with: '),
        // Здесь можно добавить кнопки для других способов входа
      ],
    );
  }
}
