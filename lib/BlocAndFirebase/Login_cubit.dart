// ignore_for_file: file_names, unused_local_variable, prefer_const_constructors

import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuhoc_cty/BlocAndFirebase/Login_State.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  Stream<String> get emailStream => _emailController.stream;
  Stream<String> get passwordStream => _passwordController.stream;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _email = '';
  String _pass = '';

  void emailChangeed(String email) {
    _emailController.sink.add(email);
  }

  void passwordChanged(String pass) {
    _passwordController.sink.add(pass);
  }

  Future<void> login() async {
    emit(LoginLoading());

    _emailController.stream.listen((email) {
      _email = email;
    }).onError((error) {
      _email = '';
      emit(LoginFailure('Invalid Email'));
    });

    _passwordController.stream.listen((pass) {
      _pass = pass;
    }).onError((error) {
      _pass = '';
      emit(LoginFailure('Invalid Password'));
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _email,
        password: _pass,
      );

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure('Wrong password provided.'));
      } else {
        emit(LoginFailure('Login failed: ${e.message}'));
      }
    } catch (e) {
      emit(LoginFailure('An error occurred. Please try again.'));
    }
  }

  Future<void> register() async {
    emit(LoginLoading());

    _emailController.stream.listen((email) {
      _email = email;
    }).onError((error) {
      _email = '';
      emit(LoginFailure('Invalid Email'));
    });

    _passwordController.stream.listen((pass) {
      _pass = pass;
    }).onError((error) {
      _pass = '';
      emit(LoginFailure('Invalid Password'));
    });

    await Future.delayed(Duration(seconds: 2));

    try {
      await _auth.createUserWithEmailAndPassword(
          email: _email, password: _pass);

      emit(LoginSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        emit(LoginFailure('No user found for that email.'));
      } else if (e.code == 'wrong-password') {
        emit(LoginFailure('Wrong password provided.'));
      } else {
        emit(LoginFailure('Login failed: ${e.message}'));
      }
    } catch (e) {
      emit(LoginFailure('An error occurred. Please try again.'));
    }
  }

  @override
  Future<void> close() {
    _emailController.close();
    _passwordController.close();
    return super.close();
  }
}
