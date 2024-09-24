// ignore_for_file: prefer_const_constructors_in_immutables, use_key_in_widget_constructors, library_private_types_in_public_api, avoid_print, prefer_conditional_assignment, unnecessary_null_comparison

import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart'; // Import path_provider
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
  late String _initialMood;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates();
    _moodIcons = MoodIcons();
    _noteController = TextEditingController(text: widget.note);
    _initialMood = widget.mood;
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
    _journalEditBloc.moodEditChanged.add(widget.mood);
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

  Future<void> _updateJournal() async {
    try {
      String note = _noteController.text;
      String date = _journalEditBloc.currentDate;
      String mood = _journalEditBloc.currentMood;
      if (mood.isEmpty) {
        mood = _initialMood;
      }
      DateTime dateTime = DateTime.parse(date);

      final directory = await getApplicationDocumentsDirectory();
      final journalDirectory = Directory('${directory.path}/journals');
      final file = File('${journalDirectory.path}/journals.txt');

      List<Map<String, dynamic>> journalList = [];
      if (await file.exists()) {
        String contents = await file.readAsString();
        journalList = List<Map<String, dynamic>>.from(json.decode(contents));
      }

      final journalMap = {
        for (var journal in journalList) journal['id']: journal
      };

      if (journalMap.containsKey(widget.entryId)) {
        final entry = journalMap[widget.entryId]!;
        entry['date'] = dateTime.toIso8601String();
        entry['mood'] = mood;
        entry['note'] = note;

        journalList = journalMap.values.toList();
        await file.writeAsString(json.encode(journalList));
        _showSuccessDialog("Entry updated successfully");
      } else {
        print('Entry ID not found.');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  void _showSuccessDialog(String note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text('Journal entry saved: $note'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Return to previous screen
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
        title: const Text('Entry',
            style: TextStyle(color: Color.fromARGB(255, 111, 172, 242))),
        automaticallyImplyLeading: false,
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 137, 192, 238),
                Color.fromARGB(255, 109, 176, 247)
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 127, 196, 249),
        child: SafeArea(
          minimum: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
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
                StreamBuilder<String>(
                  stream: _journalEditBloc.moodEdit,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    // Kiểm tra nếu snapshot có giá trị, dùng nó, nếu không dùng giá trị từ widget.mood
                    String selectedMood = snapshot.data ?? widget.mood;
                    print('Selected Mood: $selectedMood');

                    // Lấy danh sách các MoodIcon và sắp xếp sao cho widget.mood xuất hiện đầu tiên
                    List<MoodIcon> moodIconsList =
                        _moodIcons.getMoodIconsList();
                    moodIconsList.sort((a, b) {
                      if (a.title == widget.mood) return -1;
                      if (b.title == widget.mood) return 1;
                      return 0;
                    });

                    // Chọn icon tương ứng với mood hiện tại
                    MoodIcon selectedMoodIcon = moodIconsList.firstWhere(
                      (icon) => icon.title == selectedMood,
                      orElse: () => moodIconsList[0],
                    );

                    return DropdownButtonHideUnderline(
                      child: DropdownButton<MoodIcon>(
                        // Giá trị hiển thị mặc định
                        value: selectedMoodIcon,
                        onChanged: (MoodIcon? selected) {
                          if (selected != null) {
                            setState(() {
                              _initialMood = selected.title;
                            });
                            // Cập nhật giá trị mood đã chọn
                            _journalEditBloc.moodEditChanged
                                .add(selected.title);
                          } else {
                            // Nếu không có lựa chọn, giữ nguyên giá trị mood ban đầu
                            setState(() {
                              _initialMood =
                                  widget.mood; // Giữ giá trị mood ban đầu
                            });
                            _journalEditBloc.moodEditChanged
                                .add(widget.mood); // Cập nhật giá trị mood
                          }
                        },
                        items: moodIconsList.map((MoodIcon moodIcon) {
                          return DropdownMenuItem<MoodIcon>(
                            value: moodIcon,
                            child: Row(
                              children: <Widget>[
                                Transform(
                                  transform: Matrix4.identity()
                                    ..rotateZ(moodIcon.rotation),
                                  alignment: Alignment.center,
                                  child: Icon(moodIcon.icon,
                                      color: moodIcon.color),
                                ),
                                const SizedBox(width: 16.0),
                                // Hiển thị tên mood
                                Text(moodIcon.title),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    );
                  },
                ),
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
                        await _updateJournal();
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
