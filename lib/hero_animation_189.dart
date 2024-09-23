// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';

class HeroAnimation extends StatefulWidget {
  const HeroAnimation({super.key});

  @override
  State<HeroAnimation> createState() => _HeroAnimationState();
}

class _HeroAnimationState extends State<HeroAnimation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Tap on the image to see the hero animation'),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Fly(),
                  ),
                );
              },
              child:
                  const Hero(tag: 'imageHero', child: Icon(Icons.format_paint)),
            ),
          ],
        ),
      ),
    );
  }
}

class Fly extends StatefulWidget {
  const Fly({super.key});

  @override
  State<Fly> createState() => _FlyState();
}

class _FlyState extends State<Fly> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.shortestSide / 2;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hero Animation'),
      ),
      body: SafeArea(
          child: Hero(
              tag: 'format_paint',
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Icon(
                  Icons.format_paint,
                  color: Colors.lightGreen,
                  size: _width,
                ),
              ))),
    );
  }
}
