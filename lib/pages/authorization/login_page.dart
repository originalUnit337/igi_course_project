import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return Scaffold(
    //   appBar: AppBar(
    //     title: Text('Login'),
    //   ),
    //   body: Row(
    //     children: [
    //       //Placeholder(),
    //       Column(
    //         children: [
    //           Text('Please login to get access to bla-bla-bla'),
    //           TextField(
    //             decoration: InputDecoration(
    //               labelText: 'Email',
    //               border: OutlineInputBorder(),
    //             ),
    //             keyboardType: TextInputType.emailAddress,
    //           ),
    //           TextField(
    //             decoration: InputDecoration(
    //               labelText: 'Password',
    //               border: OutlineInputBorder(),
    //             ),
    //             obscureText: true,
    //           ),
    //           ElevatedButton(
    //             onPressed: () {},
    //             child: Text('Login'),
    //           ),
    //           Divider(),
    //           Text('Or login with: '),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0), // Добавляем отступы
        child: Row(
          children: [
            Expanded(
              child: Image.asset('login_img.png'),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Центрируем содержимое
                children: [
                  Text(
                    'Please login to get access to bla-bla-bla',
                    style: TextStyle(fontSize: 18),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20), // Отступ между текстом и полями ввода
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  SizedBox(height: 16), // Отступ между полями ввода
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                  SizedBox(height: 20), // Отступ между полем ввода и кнопкой
                  ElevatedButton(
                    onPressed: () {
                      // Логика для входа
                    },
                    child: Text('Login'),
                  ),
                  SizedBox(height: 20), // Отступ между кнопкой и разделителем
                  Divider(),
                  SizedBox(height: 20), // Отступ между разделителем и текстом
                  Text('Or login with: '),
                  // Здесь можно добавить кнопки для других способов входа
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
