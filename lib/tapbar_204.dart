import 'package:flutter/material.dart';

class TabControllerExample extends StatefulWidget {
  @override
  _TabControllerExampleState createState() => _TabControllerExampleState();
}

class _TabControllerExampleState extends State<TabControllerExample>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TabController Example'),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.star), text: "Star"),
            Tab(icon: Icon(Icons.settings), text: "Settings"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text("Home Page")),
          Center(child: Text("Star Page")),
          Center(child: Text("Settings Page")),
        ],
      ),
    );
  }
}
