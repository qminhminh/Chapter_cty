// ignore_for_file: avoid_print

import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';

class AuthenticationBloc {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Stream quản lý trạng thái người dùng
  Stream<User?> get user => _firebaseAuth.authStateChanges();

  // Đăng nhập với email và mật khẩu
  Future<void> signIn(String email, String password) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print("Login Failed: $e");
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
