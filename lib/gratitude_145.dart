// ignore_for_file: prefer_final_fields, avoid_print

import 'package:flutter/material.dart';

class Gratitude extends StatefulWidget {
  final int radioGroupValue;
  const Gratitude({super.key, required this.radioGroupValue});

  @override
  State<Gratitude> createState() => _GratitudeState();
}

class _GratitudeState extends State<Gratitude> {
  List<String> _gratitudeList = [];
  String? _selectedGratitude;
  int? _radioGroupValue;
  void _radioOnChanged(int index) {
    setState(() {
      _radioGroupValue = index;
      _selectedGratitude = _gratitudeList[index];
      print('_selectedRadioValue $_selectedGratitude');
    });
  }

  @override
  void initState() {
    super.initState();
    _gratitudeList
      ..add('Family')
      ..add('Friends')
      ..add('Coffee');
    _radioGroupValue = widget.radioGroupValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gratitude'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () => Navigator.pop(context, _selectedGratitude),
          )
        ],
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Radio(
              value: 0,
              groupValue: _radioGroupValue,
              onChanged: (index) => _radioOnChanged(index!),
            ),
            const Text('Family'),
            Radio(
              value: 1,
              groupValue: _radioGroupValue,
              onChanged: (index) => _radioOnChanged(index!),
            ),
            const Text('Friends'),
            Radio(
              value: 2,
              groupValue: _radioGroupValue,
              onChanged: (index) => _radioOnChanged(index!),
            ),
            const Text('Coffee'),
          ],
        ),
      )),
    );
  }
}
