import 'dart:async';
import 'validators.dart';
import 'authentication_bloc.dart';

class LoginBloc {
  AuthenticationBloc _authBloc; // Remove final

  // StreamController for email and password
  final _emailController = StreamController<String>();
  final _passwordController = StreamController<String>();

  // Store latest values
  String _latestEmail = '';
  String _latestPassword = '';

  // Initialize _authBloc in the constructor
  LoginBloc(this._authBloc);

  // Combine validators to check data
  Stream<String> get email =>
      _emailController.stream.transform(Validators.validateEmail);

  Stream<String> get password =>
      _passwordController.stream.transform(Validators.validatePassword);

  // Add data to streams and update latest values
  Function(String) get changeEmail => (email) {
        _latestEmail = email;
        _emailController.sink.add(email);
      };

  Function(String) get changePassword => (password) {
        _latestPassword = password;
        _passwordController.sink.add(password);
      };

  // Login method
  void submitlogin() {
    final validEmail = _latestEmail;
    final validPassword = _latestPassword;

    if (validEmail.isNotEmpty && validPassword.isNotEmpty) {
      _authBloc.signIn(validEmail, validPassword);
    }
  }

  void submitregister() {
    final validEmail = _latestEmail;
    final validPassword = _latestPassword;

    if (validEmail.isNotEmpty && validPassword.isNotEmpty) {
      _authBloc.register(validEmail, validPassword);
    }
  }

  void dispose() {
    _emailController.close();
    _passwordController.close();
  }
}
