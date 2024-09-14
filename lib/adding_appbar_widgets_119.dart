import 'package:flutter/material.dart';

class AddAppBarWidgets extends StatefulWidget {
  const AddAppBarWidgets({super.key});

  @override
  State<AddAppBarWidgets> createState() => _AddAppBarWidgetsState();
}

class _AddAppBarWidgetsState extends State<AddAppBarWidgets> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            // do something
          },
        ),
        title: const Text('Widget tree'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // do something
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // do something
            },
          ),
        ],
        flexibleSpace: const SafeArea(
            child: Icon(
          Icons.photo_camera,
          size: 75.0,
          color: Colors.lightGreen,
        )),
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(75.0),
            child: Container(
              color: Colors.lightGreen,
              height: 75.0,
              width: double.infinity,
              child: const Center(
                child: Text('Bottom'),
              ),
            )),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SafeArea(
            child: SingleChildScrollView(
          child: Column(children: <Widget>[
            ContainerWithBoxDecorationWidget(),
            // Divider(),
            // ColumnWidget(),
            // Divider(),
            // RootWidget(),
            // Divider(),
            // ColumnAndRowNestingWidget(),
            Divider(),
            ButtonsWidget(),
            Divider(),
            ButtonBarWidget(),
          ]),
        )),
      ),
    );
  }
}

class ButtonBarWidget extends StatelessWidget {
  const ButtonBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white70,
      child: ButtonBar(
        alignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.airport_shuttle),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.brush),
            highlightColor: Colors.purple,
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

class ButtonsWidget extends StatelessWidget {
  const ButtonsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(16.0)),
            TextButton(
              child: const Text(
                'Flag',
                style: TextStyle(fontSize: 20.0),
              ),
              onPressed: () {},
            ),
            const Padding(padding: EdgeInsets.all(16.0)),
            TextButton(
              onPressed: () {},
              child: const Icon(Icons.flag),
            )
          ],
        ),
        const Divider(),
        Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(16.0)),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Save'),
            ),
            const Padding(padding: EdgeInsets.all(16.0)),
            ElevatedButton(
              onPressed: () {},
              child: const Icon(Icons.save),
            ),
          ],
        ),
        const Divider(),
        Row(
          children: <Widget>[
            const Padding(padding: EdgeInsets.all(16.0)),
            IconButton(
              icon: const Icon(Icons.flight),
              onPressed: () {},
            ),
            const Padding(padding: EdgeInsets.all(16.0)),
            IconButton(
              icon: const Icon(Icons.flight),
              iconSize: 42.0,
              color: Colors.lightGreen,
              tooltip: 'Flight',
              onPressed: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class ContainerWithBoxDecorationWidget extends StatelessWidget {
  const ContainerWithBoxDecorationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          height: 100,
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(100.0),
              bottomRight: Radius.circular(10.0),
            ),
            gradient: LinearGradient(
              colors: <Color>[
                Colors.white,
                Colors.lightGreen,
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 10.0,
                offset: Offset(0, 10),
              )
            ],
          ),
          child: const Center(
            child: Text('Container with BoxDecoration'),
          ),
        ),
      ],
    );
  }
}

class ColumnWidget extends StatelessWidget {
  const ColumnWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text('Column 1'),
        Divider(),
        Text('Column 2'),
        Divider(),
        Text('Column 3'),
      ],
    );
  }
}

class RowWidget extends StatelessWidget {
  const RowWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text('Row 1'),
            Padding(
              padding: EdgeInsets.all(16.0),
            ),
            Text('Row 2'),
            Padding(
              padding: EdgeInsets.all(16.0),
            ),
            Text('Row 3'),
          ],
        ),
      ],
    );
  }
}

class ColumnAndRowNestingWidget extends StatelessWidget {
  const ColumnAndRowNestingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Text(
          'Columns and Row Nesting 1',
        ),
        Text(
          'Columns and Row Nesting 2',
        ),
        Text(
          'Columns and Row Nesting 3',
        ),
        Padding(
          padding: EdgeInsets.all(16.0),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text('Row Nesting 1'),
            Text('Row Nesting 2'),
            Text('Row Nesting 3'),
          ],
        ),
      ],
    );
  }
}
