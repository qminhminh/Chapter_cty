// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'login_bloc.dart';

class LoginPage extends StatelessWidget {
  final LoginBloc _loginBloc;

  LoginPage(this._loginBloc);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            StreamBuilder<String>(
              stream: _loginBloc.email,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: _loginBloc.changeEmail,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    errorText:
                        snapshot.error?.toString(), // Ensure error is a String
                  ),
                );
              },
            ),
            StreamBuilder<String>(
              stream: _loginBloc.password,
              builder: (context, snapshot) {
                return TextField(
                  onChanged: _loginBloc.changePassword,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    errorText:
                        snapshot.error?.toString(), // Ensure error is a String
                  ),
                );
              },
            ),
            ElevatedButton(
              onPressed: () {
                _loginBloc.submit();
              },
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
