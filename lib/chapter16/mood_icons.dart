import 'package:flutter/material.dart';

class MoodIcons {
  // Return a list of moods with their corresponding icons
  List<MoodIcon> getMoodIconsList() {
    return [
      MoodIcon(
        title: 'Very Satisfied',
        icon: Icons.sentiment_very_satisfied,
        color: Colors.green,
        rotation: 0.0,
      ),
      MoodIcon(
        title: 'Satisfied',
        icon: Icons.sentiment_satisfied,
        color: Colors.lightGreen,
        rotation: 0.0,
      ),
      MoodIcon(
        title: 'Neutral',
        icon: Icons.sentiment_neutral,
        color: Colors.orange,
        rotation: 0.0,
      ),
      MoodIcon(
        title: 'Dissatisfied',
        icon: Icons.sentiment_dissatisfied,
        color: Colors.red,
        rotation: 0.0,
      ),
      MoodIcon(
        title: 'Very Dissatisfied',
        icon: Icons.sentiment_very_dissatisfied,
        color: Colors.redAccent,
        rotation: 0.0,
      ),
    ];
  }

  // Return mood icon by title
  IconData getMoodIcon(String title) {
    return getMoodIconsList().firstWhere((mood) => mood.title == title).icon;
  }

  // Return mood color by title
  Color getMoodColor(String title) {
    return getMoodIconsList().firstWhere((mood) => mood.title == title).color;
  }

  // Return mood rotation by title
  double getMoodRotation(String title) {
    return getMoodIconsList()
        .firstWhere((mood) => mood.title == title)
        .rotation;
  }
}

class MoodIcon {
  final String title;
  final IconData icon;
  final Color color;
  final double rotation;

  MoodIcon(
      {required this.title,
      required this.icon,
      required this.color,
      required this.rotation});
}
