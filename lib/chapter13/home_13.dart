// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print, unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tuhoc_cty/chapter13/addd_13.dart';
import 'package:tuhoc_cty/chapter13/editt_13.dart';
import 'package:tuhoc_cty/chapter13/jouney_model.dart';
import 'dart:convert';
import 'dart:io';

import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart';
import 'package:tuhoc_cty/chapter16/authentication_bloc.dart';
import 'package:tuhoc_cty/chapter16/mood_icons.dart';

class HomePage extends StatefulWidget {
  final AuthenticationBloc _authBloc;

  HomePage(this._authBloc);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<JournalEntry> journalEntries = [];

  @override
  void initState() {
    super.initState();
    _loadJournalEntries();
    print("journalEntries: " + journalEntries.toString());
  }

  Future<void> _loadJournalEntries() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final journalDirectory = Directory('${directory.path}/journals');
      final file = File('${journalDirectory.path}/journals.txt');
      if (await file.exists()) {
        String savedEntries = await file.readAsString();
        List<Map<String, dynamic>> entriesList =
            List<Map<String, dynamic>>.from(json.decode(savedEntries));

        // Debugging log to check if data is read correctly
        print('Loaded entries: $entriesList');

        setState(() {
          journalEntries =
              entriesList.map((entry) => JournalEntry.fromMap(entry)).toList();

          // Sort the journal entries by date (descending)
          journalEntries.sort((entry1, entry2) {
            DateTime date1 = DateTime.parse(entry1.date);
            DateTime date2 = DateTime.parse(entry2.date);
            return date2.compareTo(date1);
          });
        });
      } else {
        print('File does not exist');
      }
    } catch (e) {
      print('Error loading journal entries: $e');
    }
  }

  Future<void> _deleteJournalEntry(int index) async {
    setState(() {
      journalEntries.removeAt(index);
    });
    await _saveJournalEntries();
  }

  Future<void> _saveJournalEntries() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final journalDirectory = Directory('${directory.path}/journals');
      final file = File('${journalDirectory.path}/journals.txt');
      List<Map<String, dynamic>> entriesList =
          journalEntries.map((entry) => entry.toMap()).toList();
      await file.writeAsString(json.encode(entriesList));

      // Debugging log to check if data is saved correctly
      print('Saved entries: ${entriesList}');
    } catch (e) {
      print('Error saving journal entries: $e');
    }
  }

  Future<void> _refreshData() async {
    await _loadJournalEntries(); // Reload data when refreshed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Local Reference'),
        elevation: 0.0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Color.fromARGB(255, 144, 202, 249)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              widget._authBloc.signOut();
            },
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 255, 255, 255),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: journalEntries.isEmpty
              ? const Center(child: Text('No entries available'))
              : ListView.builder(
                  itemCount: journalEntries.length,
                  itemBuilder: (context, index) {
                    var entry = journalEntries[index];
                    var moodIcons = MoodIcons();
                    // ignore: prefer_for_elements_to_map_fromiterable
                    var moodIconMap = Map<String, MoodIcon>.fromIterable(
                      moodIcons.getMoodIconsList(),
                      key: (mood) => mood.title,
                      value: (mood) => mood,
                    );
                    var mood = entry.mood;
                    var moodIcon = moodIconMap[mood] ??
                        MoodIcon(
                          title: 'Unknown',
                          icon: Icons.error,
                          color: Colors.black,
                          rotation: 0.0,
                        );
                    final DateTime dateTime = DateTime.parse(entry.date);
                    final formattedDate = DateFormat('EEE').format(dateTime);
                    final formattedDay = DateFormat('dd').format(dateTime);
                    final formattedMonthYear =
                        DateFormat('MMM dd, yyyy').format(dateTime);

                    return Dismissible(
                      key: ValueKey(index),
                      background: _buildCompleteTrip(),
                      secondaryBackground: _buildRemoveTrip(),
                      confirmDismiss: (DismissDirection direction) async {
                        return await _showDeleteConfirmationDialog(index);
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JournalEditBlocProvider(
                                journalEditBloc: JournalEditBloc(),
                                child: EditEntry(
                                  entryId: entry.id,
                                  date: dateTime,
                                  note: entry.note,
                                  mood: entry.mood,
                                ),
                              ),
                            ),
                          ).then((value) {
                            if (value == true) {
                              _loadJournalEntries(); // Reload data after edit
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3.0),
                          child: Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          formattedDay,
                                          style: const TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Color.fromARGB(
                                                255, 65, 153, 225),
                                          ),
                                        ),
                                        Text(
                                          formattedDate,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 16.0),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formattedMonthYear,
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Row(
                                            children: [
                                              Icon(
                                                moodIcon
                                                    .icon, // Placeholder for mood icon
                                                color: moodIcon.color,
                                                size: 20.0,
                                              ),
                                              const SizedBox(
                                                height: 4,
                                              ),
                                              Text(moodIcon.title)
                                            ],
                                          ),
                                          Text(
                                            entry.note,
                                            style: const TextStyle(
                                              fontSize: 14,
                                              color: Colors.black54,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        mini: true,
        shape: const CircleBorder(),
        elevation: 10.0,
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JournalEditBlocProvider(
                journalEditBloc: JournalEditBloc(),
                child: EditEntryAdd(),
              ),
            ),
          ).then((value) {
            if (value == true) {
              _loadJournalEntries(); // Reload data after adding new entry
            }
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: const CircularNotchedRectangle(),
        color: Colors.blue,
        notchMargin: 8.0,
        child: Container(),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(int index) async {
    bool? deleteConfirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Journal"),
          content:
              const Text("Are you sure you want to delete this journal entry?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed == true) {
      await _deleteJournalEntry(index);
    }

    return deleteConfirmed == true;
  }
}

Container _buildCompleteTrip() {
  return Container(
    color: Colors.red,
    child: const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Icon(
            Icons.done,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}

Container _buildRemoveTrip() {
  return Container(
    color: Colors.red,
    child: const Padding(
      padding: EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
        ],
      ),
    ),
  );
}
