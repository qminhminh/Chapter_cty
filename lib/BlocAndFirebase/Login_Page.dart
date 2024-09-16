import 'package:flutter/material.dart';
import '../chapter16/login_bloc.dart';

class LoginPage extends StatelessWidget {
  final LoginBloc _loginBloc;

  LoginPage(this._loginBloc); // Ensure constructor accepts LoginBloc

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
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
                _loginBloc.submitlogin();
              },
              child: const Text('Login'),
            )
          ],
        ),
      ),
    );
  }
}
