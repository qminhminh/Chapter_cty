// ignore_for_file: unused_import, deprecated_member_use, use_key_in_widget_constructors

// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tuhoc_cty/BlocAndFirebase/Login_Page.dart';
// import 'package:tuhoc_cty/BlocAndFirebase/Login_cubit.dart';
// import 'package:tuhoc_cty/Sliverlist_widget_246.dart';
// import 'package:tuhoc_cty/adding_appbar_widgets_119.dart';
// import 'package:tuhoc_cty/bottom_natigation_bar_193.dart';
// import 'package:tuhoc_cty/chapter16/authentication_bloc.dart';
// import 'package:tuhoc_cty/chapter16/home_page.dart';
// import 'package:tuhoc_cty/chapter16/login_bloc.dart';
// import 'package:tuhoc_cty/checking_orientation_143.dart';
// import 'package:tuhoc_cty/craete_animation_container_app_152.dart';
// import 'package:tuhoc_cty/createtheform_validate_app_140.dart';
// import 'package:tuhoc_cty/creatting_images_project_133.dart';
// import 'package:tuhoc_cty/dismissible_296.dart';
// import 'package:tuhoc_cty/drag_drop_272.dart';
// import 'package:tuhoc_cty/drawer_216.dart';
// import 'package:tuhoc_cty/firebase_options.dart';
// import 'package:tuhoc_cty/gratitude_145.dart';
// import 'package:tuhoc_cty/gridview_234.dart';
// import 'package:tuhoc_cty/listview_listitle.dart';
// import 'package:tuhoc_cty/stack_238.dart';
// import 'package:tuhoc_cty/tapbar_204.dart';

// import 'hero_animation_189.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tuhoc_cty/BlocAndFirebase/Login_cubit.dart';
import 'package:tuhoc_cty/chapter16/authentication_bloc.dart';
import 'package:tuhoc_cty/chapter16/home_page.dart';
import 'package:tuhoc_cty/chapter16/login_bloc.dart';
import 'package:tuhoc_cty/chapter16/login_page.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart';
import 'package:tuhoc_cty/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => LoginCubit(),
        ),
        // You can add other BlocProviders here if needed
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AuthenticationBloc _authBloc = AuthenticationBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
        canvasColor: Colors.lightGreen.shade50,
        bottomAppBarColor: Colors.lightGreen,
      ),
      home: StreamBuilder(
        stream: _authBloc.user,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return JournalEditBlocProvider(
              journalEditBloc: JournalEditBloc(),
              child: HomePage(_authBloc),
            );
          } else {
            return LoginPage(
                LoginBloc(_authBloc)); // Pass AuthenticationBloc here
          }
        },
      ),
    );
  }
}


// `EditEntry` class here...

// `JournalEditBlocProvider` class here...


// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Flutter Demo',
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//         useMaterial3: true,
//       ),
//       home: LoginPage(),
//     );
//   }
// }
