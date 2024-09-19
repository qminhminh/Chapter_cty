// ignore_for_file: avoid_print

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<void> register(String email, String password, String image) async {
    try {
      final UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Lấy User ID
      final String uid = userCredential.user!.uid;

      // Lưu thông tin người dùng vào Firestore với ID người dùng
      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'id': uid,
        'image': image,
        'email': email,
        'password': password,
      });
    } catch (e) {
      print("Login Failed: $e");
    }
  }

  // Đăng xuất
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
