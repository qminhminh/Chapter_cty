// ignore_for_file: prefer_const_declarations, unused_field, library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'login_bloc.dart';

class LoginPage extends StatefulWidget {
  final LoginBloc _loginBloc;

  LoginPage(this._loginBloc);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  String? _imageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _pickImage,
                  child: _imageFile != null
                      ? CircleAvatar(
                          radius: 50, // Adjust the radius as per your design
                          backgroundImage: FileImage(File(_imageFile!.path)),
                        )
                      : const CircleAvatar(
                          radius: 50, // Adjust the radius as per your design
                          backgroundImage:
                              AssetImage('assets/images/download.png'),
                        ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<String>(
                  stream: widget._loginBloc.email,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: widget._loginBloc.changeEmail,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.email),
                        filled: true,
                        fillColor: Colors.grey[200],
                        errorText: snapshot.error?.toString(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                StreamBuilder<String>(
                  stream: widget._loginBloc.password,
                  builder: (context, snapshot) {
                    return TextField(
                      onChanged: widget._loginBloc.changePassword,
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        prefixIcon: const Icon(Icons.password),
                        filled: true,
                        fillColor: Colors.grey[200],
                        labelText: 'Password',
                        errorText: snapshot.error?.toString(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    widget._loginBloc.submitlogin();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 30.0),
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                const SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    if (_imageFile != null) {
                      _uploadData();
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text(
                                'Thông báo',
                                style: TextStyle(
                                    fontFamily: FontWeight.bold.toString(),
                                    color: Colors.red),
                              ),
                              content: const Text(
                                'Vui lòng chọn ảnh',
                                style: TextStyle(color: Colors.red),
                              ),
                              actions: [
                                TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('OK'))
                              ],
                            );
                          });
                    } // Call _uploadData to handle image upload and registration
                  },
                  child: Text('Tạo tài khoản',
                      style: TextStyle(
                          fontFamily: FontWeight.bold.toString(),
                          fontSize: 20)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });
    }
  }

  Future<void> _uploadData() async {
    if (_imageFile == null) {
      // Handle the case when there is no image selected
      return;
    }

    final storageRef = FirebaseStorage.instance
        .ref()
        .child('images/${DateTime.now().toString()}');
    final uploadTask = storageRef.putFile(File(_imageFile!.path));

    final snapshot = await uploadTask.whenComplete(() {});
    final downloadUrl = await snapshot.ref.getDownloadURL();
    await widget._loginBloc.submitregister(downloadUrl);

    // Optionally, handle the result or navigate to another page
  }
}
