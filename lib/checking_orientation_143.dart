import 'package:flutter/material.dart';

class OrientationApp extends StatelessWidget {
  const OrientationApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              OrientationLayoutIconsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}

class OrientationLayoutIconsWidget extends StatelessWidget {
  const OrientationLayoutIconsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    Orientation _orientation = MediaQuery.of(context).orientation;
    return _orientation == Orientation.portrait
        ? const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.school,
                size: 48.0,
              )
            ],
          )
        : const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.school,
                size: 48.0,
              ),
              Icon(
                Icons.brush,
                size: 48.0,
              ),
            ],
          );
  }
}
