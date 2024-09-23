import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io'; // For file operations
import 'dart:convert'; // For JSON encoding and decoding
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

  Future<void> _addJournal() async {
    try {
      String note = _noteController.text;
      String date = _journalEditBloc.currentDate;
      String mood = _journalEditBloc.currentMood;

      DateTime dateTime = DateTime.parse(date);

      // Get the path to the app's documents directory
      final directory = await getApplicationDocumentsDirectory();
      final journalDirectory = Directory('${directory.path}/journals');

      // Create the directory if it doesn't exist
      if (!await journalDirectory.exists()) {
        await journalDirectory.create(recursive: true);
      }

      final file = File('${journalDirectory.path}/journals.txt');

      print('File path: ${file.path}'); // Debugging line

      // Read existing data if the file exists
      List<Map<String, dynamic>> journalList = [];
      if (await file.exists()) {
        String contents = await file.readAsString();
        journalList = List<Map<String, dynamic>>.from(json.decode(contents));
        print('Read data: $journalList'); // Debugging line
      } else {
        print('File does not exist, creating a new one.'); // Debugging line
      }

      // Add new entry
      String newEntryId = DateTime.now().millisecondsSinceEpoch.toString();
      journalList.add({
        'id': newEntryId,
        'date': dateTime.toIso8601String(),
        'mood': mood,
        'note': note,
      });

      // Save data to file
      await file.writeAsString(json.encode(journalList), mode: FileMode.write);

      _showSuccessDialog('Journal entry saved successfully.');
    } catch (e) {
      print('Error: $e'); // Improved error logging
      _showErrorDialog('Failed to save entry: $e');
    }
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
                Navigator.pop(context, true); // Return to the previous screen
              },
            ),
          ],
        );
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.pop(context); // Close dialog
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
              colors: [
                const Color.fromARGB(255, 133, 180, 255),
                Colors.lightGreen.shade50
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 115, 179, 247),
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
                    return DropdownButtonHideUnderline(
                      child: DropdownButton<MoodIcon>(
                        value: selectedMoodIcon,
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
                                  child: Icon(mood.icon,
                                      size: 24.0, color: mood.color),
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
                  textInputAction: TextInputAction.newline,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Note',
                    icon: Icon(Icons.subject),
                  ),
                  maxLines: null,
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
                        await _addJournal();
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
}
