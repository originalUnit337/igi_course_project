import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:igi_course_project/DAL/models/user_models/admin.dart';
import 'package:igi_course_project/DAL/models/user_models/student.dart';
import 'package:igi_course_project/DAL/models/user_models/teacher.dart';
import 'package:igi_course_project/DAL/models/user_models/user.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<UserModel?> signIn(String email, String password) async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot doc =
            await _firestore.collection('users').doc(user.uid).get();

        if (doc.exists) {
          String role = doc['role'];
          return await _getUserByRole(user.uid, role);
        }
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<UserModel?> signUp(String email, String password, String role) async {
    try {
      UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        // await _firestore.collection('users').doc(user.uid).set({
        //   'email': email,
        //   'role': role,
        // });
        if (role == 'student') {
          await _firestore.collection('users').doc(user.uid).set({
            'email': email,
            'role': role,
            'subcribedCourses': [],
          });
        }
        if (role == 'teacher') {
          await _firestore.collection('users').doc(user.uid).set({
            'email': email,
            'role': role,
            'createdCourses': [],
          });
        }
        //return await _getUserByRole(user.uid, role);
        return await signIn(email, password);
      }
      return null;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<UserModel?> _getUserByRole(String uid, String role) async {
    DocumentSnapshot doc = await _firestore.collection('users').doc(uid).get();

    if (doc.exists) {
      String email = doc['email'];

      switch (role) {
        case 'teacher':
          final createdCourses = doc['createdCourses'];
          return Teacher(
              uid: uid, email: email, createdCourses: createdCourses);
        case 'student':
          final subscribedCourses = doc['subscribedCourses'];
          return Student(
              uid: uid, email: email, subscribedCourses: subscribedCourses);
        case 'admin':
          return Admin(uid: uid, email: email);
        default:
          return null; // Если роль не распознана
      }
    }
    return null; // Если документ не существует
  }
}
