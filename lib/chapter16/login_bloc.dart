// ignore_for_file: prefer_conditional_assignment

import 'dart:async';

import 'validators.dart';
import 'authentication_bloc.dart';

class LoginBloc {
  final AuthenticationBloc _authBloc;

  // Updated with .broadcast() to avoid the "Stream has already been listened to" error
  final _emailController = StreamController<String>.broadcast();
  final _passwordController = StreamController<String>.broadcast();

  String _latestEmail = '';
  String _latestPassword = '';

  LoginBloc(this._authBloc);

  // Email stream with validation
  Stream<String>? _emailStream;
  Stream<String> get email {
    if (_emailStream == null) {
      _emailStream =
          _emailController.stream.transform(Validators.validateEmail);
    }
    return _emailStream!;
  }

  // Password stream with validation
  Stream<String>? _passwordStream;
  Stream<String> get password {
    if (_passwordStream == null) {
      _passwordStream =
          _passwordController.stream.transform(Validators.validatePassword);
    }
    return _passwordStream!;
  }

  // Change email function
  Function(String) get changeEmail => (email) {
        _latestEmail = email;
        _emailController.sink.add(email);
      };

  // Change password function
  Function(String) get changePassword => (password) {
        _latestPassword = password;
        _passwordController.sink.add(password);
      };

  // Submit login function
  void submitlogin() {
    final validEmail = _latestEmail;
    final validPassword = _latestPassword;

    if (validEmail.isNotEmpty && validPassword.isNotEmpty) {
      _authBloc.signIn(validEmail, validPassword);
    }
  }

  // Submit register function
  Future<void> submitregister(String imageUrl) async {
    final validEmail = _latestEmail;
    final validPassword = _latestPassword;

    if (validEmail.isNotEmpty && validPassword.isNotEmpty) {
      await _authBloc.register(validEmail, validPassword, imageUrl);
    }
  }

  // Dispose the controllers when done
  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
