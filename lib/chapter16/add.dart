// ignore_for_file: prefer_const_constructors, avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:tuhoc_cty/chapter16/format_dates.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart';
import 'package:tuhoc_cty/chapter16/mood_icons.dart';

class EditEntryAdd extends StatefulWidget {
  @override
  _EditEntryAddState createState() => _EditEntryAddState();
}

class _EditEntryAddState extends State<EditEntryAdd> {
  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates();
    _moodIcons = MoodIcons();
    _noteController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final JournalEditBlocProvider? provider =
        JournalEditBlocProvider.of(context);
    if (provider == null) {
      throw StateError(
          'JournalEditBlocProvider không tìm thấy trong cây widget.');
    }
    _journalEditBloc = provider.journalEditBloc;
  }

  @override
  void dispose() {
    _noteController.dispose();
    _journalEditBloc.dispose();
    super.dispose();
  }

  Future<String> _selectDate(String selectedDate) async {
    DateTime initialDate = DateTime.parse(selectedDate);
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (pickedDate != null) {
      return DateTime(
        pickedDate.year,
        pickedDate.month,
        pickedDate.day,
        initialDate.hour,
        initialDate.minute,
        initialDate.second,
        initialDate.millisecond,
        initialDate.microsecond,
      ).toString();
    }
    return selectedDate;
  }

  Future<void> _addOrUpdateJournal() async {
    try {
      String note = _noteController.text;
      String date = _journalEditBloc.currentDate;
      String mood = _journalEditBloc.currentMood;

      DateTime dateTime = DateTime.parse(date);
      Timestamp timestamp = Timestamp.fromDate(dateTime);

      _showErrorDialog(timestamp.toString(), mood, note);
      String userId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference userJournals = FirebaseFirestore.instance
          .collection('journals')
          .doc(userId)
          .collection('userJournals');

      // Thêm mới document
      DocumentReference docRef = await userJournals.add({
        'date': timestamp,
        'mood': mood,
        'note': note,
      });

      // Lấy ID của document vừa thêm và cập nhật lại document với ID
      String documentId = docRef.id;
      print("New document added with ID: $documentId");

      await docRef.update({'id': documentId}).then((value) {
        print("Document updated with new ID: $documentId");

        Navigator.pop(context);
      }).catchError((error) {
        print("Failed to update document with ID: $error");
      });

      // Lưu trạng thái vào BLoC
      _journalEditBloc.saveJournalChanged.add('Save');
      // Navigator.pop(context); // Đóng màn hình sau khi lưu
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showErrorDialog(String date, String mood, String note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Test'),
          content: Text('$date + $mood + $note'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text('Entry', style: TextStyle(color: Colors.lightGreen.shade800)),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.lightGreen, Colors.lightGreen.shade50],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 201, 241, 155),
        child: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Date Picker
                StreamBuilder<String>(
                  stream: _journalEditBloc.dateEdit,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    String date = snapshot.data ?? DateTime.now().toString();
                    return TextButton(
                      onPressed: () async {
                        FocusScope.of(context).requestFocus(FocusNode());
                        String pickedDate = await _selectDate(date);
                        _journalEditBloc.dateEditChanged.add(pickedDate);
                      },
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.calendar_today,
                              size: 22.0, color: Colors.black54),
                          const SizedBox(width: 16.0),
                          Text(
                            _formatDates.dateTimeFormat(DateTime.parse(date)),
                            style: const TextStyle(
                                color: Colors.black54,
                                fontWeight: FontWeight.bold),
                          ),
                          const Icon(Icons.arrow_drop_down,
                              color: Colors.black54),
                        ],
                      ),
                    );
                  },
                ),
                // Mood Picker
                StreamBuilder<String>(
                  stream: _journalEditBloc.moodEdit,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    String mood = snapshot.data ?? 'Very Satisfied';
                    List<MoodIcon> moodIconsList =
                        _moodIcons.getMoodIconsList();
                    MoodIcon selectedMoodIcon = moodIconsList.firstWhere(
                      (icon) => icon.title == mood,
                      orElse: () => MoodIcon(
                        title: 'Very Satisfied',
                        icon: Icons.sentiment_very_satisfied,
                        color: Colors.green,
                        rotation: 0.0,
                      ),
                    );
                    bool isValidValue =
                        moodIconsList.any((icon) => icon.title == mood);
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<MoodIcon>(
                        value: isValidValue ? selectedMoodIcon : null,
                        onChanged: (MoodIcon? selected) {
                          if (selected != null) {
                            _journalEditBloc.moodEditChanged
                                .add(selected.title);
                          }
                        },
                        items: moodIconsList.map((MoodIcon mood) {
                          return DropdownMenuItem<MoodIcon>(
                            value: mood,
                            child: Row(
                              children: <Widget>[
                                Transform(
                                  transform: Matrix4.identity()
                                    ..rotateZ(mood.rotation),
                                  child: Icon(
                                    mood.icon,
                                    size: 24.0,
                                    color: mood.color,
                                  ),
                                ),
                                const SizedBox(width: 16.0),
                                Text(mood.title),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
                // Note Input
                TextField(
                  controller: _noteController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Notes',
                    border: OutlineInputBorder(),
                    hintText: 'Enter your note here',
                  ),
                ),
                // Save Button
                Container(
                  padding: const EdgeInsets.only(top: 20.0),
                  child: ElevatedButton(
                    onPressed: _addOrUpdateJournal,
                    child: const Text('Save'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
