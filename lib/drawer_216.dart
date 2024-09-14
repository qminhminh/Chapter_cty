import 'package:flutter/material.dart';

class DrawerWidget extends StatefulWidget {
  const DrawerWidget({super.key});

  @override
  State<DrawerWidget> createState() => _DrawerWidgetState();
}

class _DrawerWidgetState extends State<DrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drawer'),
      ),
      drawer: const LeftDrawerWidget(),
      endDrawer: const RightDrawerWidget(),
      body: SafeArea(
        child: Container(),
      ),
    );
  }
}

class LeftDrawerWidget extends StatefulWidget {
  const LeftDrawerWidget({super.key});

  @override
  State<LeftDrawerWidget> createState() => _LeftDrawerWidgetState();
}

class _LeftDrawerWidgetState extends State<LeftDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: const <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text('User Name'),
            accountEmail: Text('user@example.com'),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, color: Colors.blue),
            ),
          ),
          MenuListTileWidget()
        ],
      ),
    );
  }
}

class RightDrawerWidget extends StatefulWidget {
  const RightDrawerWidget({super.key});

  @override
  State<RightDrawerWidget> createState() => _RightDrawerWidgetState();
}

class _RightDrawerWidgetState extends State<RightDrawerWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

class MenuListTileWidget extends StatefulWidget {
  const MenuListTileWidget({super.key});

  @override
  State<MenuListTileWidget> createState() => _MenuListTileWidgetState();
}

class _MenuListTileWidgetState extends State<MenuListTileWidget> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
      onTap: () {
        // Handle tap
      },
    );
  }
}
