import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../DAL/repositories/authentication_repository.dart';
import '../DAL/repositories/course_repository.dart';
import '../bloc/authentication/authentication_bloc.dart';
import '../bloc/course/course_bloc.dart';

final GetIt getIt = GetIt.instance;

void setupLocator() {
  getIt.registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance);
  getIt.registerLazySingleton<CourseRepository>(
      () => CourseRepository(getIt<FirebaseFirestore>()));
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepository());
  getIt
      .registerFactory<CourseBloc>(() => CourseBloc(getIt<CourseRepository>()));
  getIt.registerFactory<AuthBloc>(() => AuthBloc(getIt<AuthRepository>()));
}
