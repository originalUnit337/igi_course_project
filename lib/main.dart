import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:igi_course_project/bloc/authentication/authentication_bloc.dart';
import 'package:igi_course_project/bloc/user/user_bloc.dart';
import 'package:igi_course_project/bloc/user_result/user_result_bloc.dart';
import 'DI/service_locator.dart';
import 'bloc/course/course_bloc.dart';
import 'firebase_options.dart';
import 'navigation/navigation.dart';
import 'pages/home_page.dart';
import 'themes/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => GetIt.I<CourseBloc>(),
        ),
        BlocProvider(
          create: (context) => GetIt.I<AuthBloc>(),
        ),
        BlocProvider(create: (context) => GetIt.I<UserBloc>()),
        BlocProvider(create: (context) => GetIt.I<UserResultBloc>()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: AppTheme.theme,
        initialRoute: '/',
        onGenerateRoute: AppNavigator.generateRoute,
        home: HomePage(),
      ),
    );
  }
}
