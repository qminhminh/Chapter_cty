// ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_key_in_widget_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tuhoc_cty/chapter16/format_dates.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart';
import 'package:tuhoc_cty/chapter16/mood_icons.dart';

class EditEntry extends StatefulWidget {
  final String entryId;
  final DateTime date;
  final String note;
  final String mood;

  EditEntry({
    required this.entryId,
    required this.date,
    required this.note,
    required this.mood,
  });

  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates();
    _moodIcons = MoodIcons();
    _noteController = TextEditingController(text: widget.note);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final JournalEditBlocProvider? provider =
        JournalEditBlocProvider.of(context);
    if (provider == null) {
      throw StateError('JournalEditBlocProvider not found in widget tree.');
    }
    _journalEditBloc = provider.journalEditBloc;
    _journalEditBloc.initialize();
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

      // Listen for changes in date and mood
      _journalEditBloc.dateEdit.listen((event) {
        setState(() {
          // Update internal state if needed
        });
      });

      _journalEditBloc.moodEdit.listen((event) {
        setState(() {
          // Update internal state if needed
        });
      });

      // Convert _testdate from String to DateTime and then to Timestamp
      String testdate = _journalEditBloc.currentDate ?? widget.date.toString();
      DateTime date = DateTime.parse(testdate);
      Timestamp timestamp = Timestamp.fromDate(date);

      // Update or add journal entry
      String userId = FirebaseAuth.instance.currentUser!.uid;
      CollectionReference userJournals = FirebaseFirestore.instance
          .collection('journals')
          .doc(userId)
          .collection('userJournals');

      // Find the document by ID
      DocumentReference docRef = userJournals.doc(widget.entryId);

      // Check if the document exists
      DocumentSnapshot docSnapshot = await docRef.get();
      if (docSnapshot.exists) {
        // Update the document
        await docRef.update({
          'date': timestamp,
          'mood': _journalEditBloc.currentMood ?? widget.mood,
          'note': note,
        });
        print("Document updated successfully with ID: ${widget.entryId}");

        Navigator.pop(context);
      } else {
        print("No journal entry found with the given ID");
      }

      // Notify BLoC of the save action
      _journalEditBloc.saveJournalChanged.add('Save');
    } catch (e) {
      print('Error: $e');
    }
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
                    String date = snapshot.data ?? widget.date.toString();
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
                    String mood = snapshot.data ?? widget.mood;
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
                                  alignment: Alignment.center,
                                  child: Icon(mood.icon, color: mood.color),
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
                // Note TextField
                StreamBuilder<String>(
                  stream: _journalEditBloc.noteEdit,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    _noteController.value = _noteController.value.copyWith(
                      text: snapshot.data ?? widget.note,
                    );
                    return TextField(
                      controller: _noteController,
                      textInputAction: TextInputAction.newline,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Note',
                        icon: Icon(Icons.subject),
                      ),
                      maxLines: null,
                      onChanged: (note) =>
                          _journalEditBloc.noteEditChanged.add(note),
                    );
                  },
                ),
                // Buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    TextButton(
                      child: const Text('Cancel'),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(width: 8.0),
                    TextButton(
                      child: const Text('Save'),
                      onPressed: () async {
                        await _addOrUpdateJournal();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
