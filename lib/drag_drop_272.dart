import 'package:flutter/material.dart';

class DragandDropApp extends StatefulWidget {
  const DragandDropApp({super.key});

  @override
  State<DragandDropApp> createState() => _DragandDropAppState();
}

class _DragandDropAppState extends State<DragandDropApp> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: SingleChildScrollView(
      child: Column(children: <Widget>[
        _buildGestureDetector(),
        const Divider(
          color: Colors.black,
          height: 44,
        ),
        _buildDraggable(),
        const Divider(
          height: 40,
        ),
        _buildDragTarget(),
        const Divider(
          color: Colors.black,
        )
      ]),
    ));
  }
}

Draggable<int> _buildDraggable() {
  return Draggable(
    childWhenDragging: const Icon(
      Icons.palette,
      color: Colors.grey,
      size: 48.0,
    ),
    feedback: const Icon(
      Icons.brush,
      color: Colors.deepOrange,
      size: 80.0,
    ),
    data: Colors.deepOrange.value,
    child: const Column(
      children: <Widget>[
        Icon(
          Icons.palette,
          color: Colors.deepOrange,
          size: 48.0,
        ),
        Text(
          'Drag Me below to change color',
        ),
      ],
    ),
  );
}

DragTarget<int> _buildDragTarget() {
  Color _paintedColor = Colors.transparent;
  return DragTarget<int>(
    onAccept: (colorValue) {
      _paintedColor = Color(colorValue);
    },
    builder: (BuildContext context, List<dynamic> acceptedData,
            List<dynamic> rejectedData) =>
        acceptedData.isEmpty
            ? Text(
                'Drag To and see color change',
                style: TextStyle(color: _paintedColor),
              )
            : Text(
                'Painting Color: $acceptedData',
                style: TextStyle(
                  color: Color(acceptedData[0]),
                  fontWeight: FontWeight.bold,
                ),
              ),
  );
}

GestureDetector _buildGestureDetector() {
  return GestureDetector(
    onTap: () {
      print('onTap');
      _displayGestureDetected('onTap');
    },
    onDoubleTap: () {
      print('onDoubleTap');

      _displayGestureDetected('onDoubleTap');
    },
    onLongPress: () {
      print('onLongPress');
      _displayGestureDetected('onLongPress');
    },
    onPanUpdate: (DragUpdateDetails details) {
      print('onPanUpdate: $details');
      _displayGestureDetected('onPanUpdate:\n$details');
    },
    child: Container(
      color: Colors.lightGreen.shade100,
      width: double.infinity,
      padding: EdgeInsets.all(24.0),
      child: Column(
        children: <Widget>[
          Icon(
            Icons.access_alarm,
            size: 98.0,
          ),
          Text('Text'),
        ],
      ),
    ),
  );
}

void _displayGestureDetected(String gesture) {
  // setState(() {
  //   _gestureDetected = gesture;
  // });
}
