import 'package:flutter/material.dart';

class BottomAppBar extends StatefulWidget {
  const BottomAppBar(
      {super.key,
      required CircularNotchedRectangle shape,
      required double notchMargin,
      required Row child});

  @override
  State<BottomAppBar> createState() => _BottomAppBarState();
}

class _BottomAppBarState extends State<BottomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Versatile BottomAppBar'),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 4.0,
        child: Row(
          children: [
            IconButton(icon: Icon(Icons.menu), onPressed: () {}),
            Spacer(),
            IconButton(icon: Icon(Icons.search), onPressed: () {}),
            IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
