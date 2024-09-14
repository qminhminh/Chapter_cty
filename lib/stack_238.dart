import 'package:flutter/material.dart';

class StackWidgeted extends StatefulWidget {
  const StackWidgeted({super.key});

  @override
  State<StackWidgeted> createState() => _StackWidgetedState();
}

class _StackWidgetedState extends State<StackWidgeted> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView.builder(
        itemCount: 7,
        itemBuilder: (BuildContext context, int index) {
          if (index.isEven) {
            return const StackWidget();
          } else {
            return const StackFavoriteWidget();
          }
        },
      ),
    );
  }
}

class StackWidget extends StatelessWidget {
  const StackWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Stack(
      children: <Widget>[
        Image(
          image: AssetImage('assets/images/logo.png'),
        ),
        Positioned(
          bottom: 10.0,
          left: 10.0,
          child: CircleAvatar(
            radius: 48.0,
            backgroundImage: AssetImage('assets/images/download.jpg'),
          ),
        ),
        Positioned(
          bottom: 16.0,
          right: 16.0,
          child: Text(
            'Lion',
            style: TextStyle(
              fontSize: 32.0,
              color: Colors.white30,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

class StackFavoriteWidget extends StatelessWidget {
  const StackFavoriteWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black87,
      child: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Stack(
          children: <Widget>[
            Image(
              image: AssetImage('assets/images/logo.png'),
            ),
            Positioned(
              top: 0.0,
              right: 0.0,
              child: FractionalTranslation(
                translation: Offset(0.3, -0.3),
                child: CircleAvatar(
                  radius: 24.0,
                  backgroundColor: Colors.white30,
                  child: Icon(
                    Icons.star,
                    size: 24.0,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 10.0,
              right: 10.0,
              child: CircleAvatar(
                radius: 48.0,
                backgroundImage: AssetImage('assets/images/eagle.jpg'),
              ),
            ),
            Positioned(
              bottom: 16.0,
              left: 16.0,
              child: Text(
                'Bald Eagle',
                style: TextStyle(
                  fontSize: 32.0,
                  color: Colors.white30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
