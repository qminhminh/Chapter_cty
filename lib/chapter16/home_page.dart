// ignore_for_file: prefer_for_elements_to_map_fromiterable, use_build_context_synchronously, avoid_print, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tuhoc_cty/chapter16/add.dart';
import 'package:tuhoc_cty/chapter16/authentication_bloc.dart';
import 'package:tuhoc_cty/chapter16/edit_entry.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';
import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart';
import 'package:tuhoc_cty/chapter16/mood_icons.dart';

class HomePage extends StatefulWidget {
  final AuthenticationBloc _authBloc;

  HomePage(this._authBloc);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Refresh function to reload data
  Future<void> _refreshData() async {
    setState(() {}); // Trigger a rebuild to refresh data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Journal Entries'),
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
        color: const Color.fromARGB(255, 201, 241, 155),
        child: RefreshIndicator(
          onRefresh: _refreshData,
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection('journals')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .collection('userJournals')
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.data == null || snapshot.data!.docs.isEmpty) {
                return const Center(child: Text('No entries available'));
              }

              var moodIcons = MoodIcons();
              var moodIconMap = Map<String, MoodIcon>.fromIterable(
                moodIcons.getMoodIconsList(),
                key: (mood) => mood.title,
                value: (mood) => mood,
              );

              var entries = snapshot.data!.docs;
              return ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  var entry = entries[index];
                  var mood = entry['mood'];
                  var moodIcon = moodIconMap[mood] ??
                      MoodIcon(
                        title: 'Unknown',
                        icon: Icons.error,
                        color: Colors.black,
                        rotation: 0.0,
                      );

                  final Timestamp timestamp = entry['date'];
                  final DateTime dateTime = timestamp.toDate();
                  final formattedDate = DateFormat('EEE').format(dateTime);
                  final formattedDay = DateFormat('dd').format(dateTime);
                  final formattedMonthYear =
                      DateFormat('MMM dd, yyyy').format(dateTime);

                  return Dismissible(
                    key: ValueKey(entry.id), // Use document ID as key
                    background: _buildCompleteTrip(),
                    secondaryBackground: _buildRemoveTrip(),
                    confirmDismiss: (DismissDirection direction) async {
                      // Show delete confirmation dialog when user swipes
                      return await _showDeleteConfirmationDialog(entry.id);
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
                                note: entry['note'],
                                mood: entry['mood'],
                              ),
                            ),
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  // Ngày và thứ
                                  Column(
                                    children: [
                                      Text(
                                        formattedDay,
                                        style: TextStyle(
                                          fontSize: 28,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.green[700],
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
                                  // Thông tin chi tiết
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
                                        Text(
                                          entry['note'],
                                          style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.black54,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Biểu tượng cảm xúc
                                  Icon(
                                    moodIcon.icon,
                                    color: moodIcon.color,
                                    size: 32.0,
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
              );
            },
          ),
        ),
      ),
      floatingActionButton: Align(
        alignment: Alignment.bottomCenter,
        child: FloatingActionButton(
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
            );
          },
        ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmationDialog(String entryId) async {
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
                Navigator.of(context)
                    .pop(false); // Close the dialog and return false
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Close the dialog and return true
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (deleteConfirmed == true) {
      try {
        String userId = FirebaseAuth.instance.currentUser!.uid;

        await FirebaseFirestore.instance
            .collection('journals')
            .doc(userId)
            .collection('userJournals')
            .doc(entryId)
            .delete();

        print("Journal entry deleted successfully");

        // Call _refreshData to reload data after deletion
        _refreshData();
      } catch (error) {
        print("Failed to delete journal entry: $error");
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Error"),
              content: Text("Failed to delete journal entry: $error"),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the error dialog
                  },
                  child: const Text('OK'),
                ),
              ],
            );
          },
        );
      }
    }

    // Return true if item should be dismissed, otherwise false
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
