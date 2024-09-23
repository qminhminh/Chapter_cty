// // ignore_for_file: unused_local_variable, use_key_in_widget_constructors, prefer_const_constructors_in_immutables

// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tuhoc_cty/chapter13/add_13.dart';
// import 'package:tuhoc_cty/chapter13/jouney_model.dart';
// import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';
// import 'dart:convert';

// import 'edit_13.dart';
// import 'package:tuhoc_cty/chapter16/authentication_bloc.dart';
// import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart';

// class HomePage extends StatefulWidget {
//   final AuthenticationBloc _authBloc;

//   HomePage(this._authBloc);

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   List<JournalEntry> journalEntries = [];

//   @override
//   void initState() {
//     super.initState();
//     _loadJournalEntries();
//   }

//   Future<void> _loadJournalEntries() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     String? savedEntries = prefs.getString('journals');

//     if (savedEntries != null) {
//       setState(() {
//         List<Map<String, dynamic>> entriesList =
//             List<Map<String, dynamic>>.from(json.decode(savedEntries));
//         journalEntries =
//             entriesList.map((entry) => JournalEntry.fromMap(entry)).toList();

//         // Sort the journal entries by date (descending)
//         journalEntries.sort((entry1, entry2) {
//           DateTime date1 = DateTime.parse(entry1.date);
//           DateTime date2 = DateTime.parse(entry2.date);
//           return date2.compareTo(date1);
//         });
//       });
//     }
//   }

//   Future<void> _saveJournalEntries() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     List<Map<String, dynamic>> entriesList =
//         journalEntries.map((entry) => entry.toMap()).toList();
//     prefs.setString('journals', json.encode(entriesList));
//   }

//   Future<void> _deleteJournalEntry(int index) async {
//     setState(() {
//       journalEntries.removeAt(index);
//     });
//     await _saveJournalEntries();
//   }

//   Future<void> _refreshData() async {
//     setState(() {});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Journal Entries'),
//         elevation: 0.0,
//         flexibleSpace: Container(
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [Colors.blue, Colors.lightGreen.shade50],
//               begin: Alignment.topCenter,
//               end: Alignment.bottomCenter,
//             ),
//           ),
//         ),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.logout),
//             onPressed: () {
//               widget._authBloc.signOut();
//             },
//           ),
//         ],
//       ),
//       body: Container(
//         color: const Color.fromARGB(255, 255, 255, 255),
//         child: RefreshIndicator(
//           onRefresh: _refreshData,
//           child: journalEntries.isEmpty
//               ? const Center(child: Text('No entries available'))
//               : ListView.builder(
//                   itemCount: journalEntries.length,
//                   itemBuilder: (context, index) {
//                     var entry = journalEntries[index];
//                     var mood = entry.mood;

//                     final DateTime dateTime = DateTime.parse(entry.date);
//                     final formattedDate = DateFormat('EEE').format(dateTime);
//                     final formattedDay = DateFormat('dd').format(dateTime);
//                     final formattedMonthYear =
//                         DateFormat('MMM dd, yyyy').format(dateTime);

//                     return Dismissible(
//                       key: ValueKey(index),
//                       background: _buildCompleteTrip(),
//                       secondaryBackground: _buildRemoveTrip(),
//                       confirmDismiss: (DismissDirection direction) async {
//                         return await _showDeleteConfirmationDialog(index);
//                       },
//                       child: GestureDetector(
//                         onTap: () {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => JournalEditBlocProvider(
//                                 journalEditBloc: JournalEditBloc(),
//                                 child: EditEntry(
//                                   entryId: entry.id,
//                                   date: dateTime,
//                                   note: entry.note,
//                                   mood: entry.mood,
//                                 ),
//                               ),
//                             ),
//                           ).then((value) {
//                             if (value == true) {
//                               _loadJournalEntries();
//                             }
//                           });
//                         },
//                         child: Padding(
//                           padding: const EdgeInsets.symmetric(vertical: 8.0),
//                           child: Container(
//                             margin: const EdgeInsets.symmetric(
//                                 horizontal: 16.0, vertical: 8.0),
//                             child: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     Column(
//                                       children: [
//                                         Text(
//                                           formattedDay,
//                                           style: const TextStyle(
//                                             fontSize: 28,
//                                             fontWeight: FontWeight.bold,
//                                             color: Color.fromARGB(
//                                                 255, 65, 153, 225),
//                                           ),
//                                         ),
//                                         Text(
//                                           formattedDate,
//                                           style: const TextStyle(
//                                             fontSize: 16,
//                                             color: Colors.grey,
//                                           ),
//                                         ),
//                                       ],
//                                     ),
//                                     const SizedBox(width: 16.0),
//                                     Expanded(
//                                       child: Column(
//                                         crossAxisAlignment:
//                                             CrossAxisAlignment.start,
//                                         children: [
//                                           Text(
//                                             formattedMonthYear,
//                                             style: const TextStyle(
//                                               fontSize: 16,
//                                               fontWeight: FontWeight.bold,
//                                               color: Colors.black87,
//                                             ),
//                                           ),
//                                           const SizedBox(height: 4),
//                                           Text(
//                                             entry.note,
//                                             style: const TextStyle(
//                                               fontSize: 14,
//                                               color: Colors.black54,
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                     const Icon(
//                                       Icons
//                                           .sentiment_satisfied, // Placeholder for mood icon
//                                       color: Colors.green,
//                                       size: 32.0,
//                                     ),
//                                   ],
//                                 ),
//                                 const Divider(),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//         ),
//       ),
//       floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
//       floatingActionButton: FloatingActionButton(
//         mini: true,
//         shape: const CircleBorder(),
//         elevation: 10.0,
//         backgroundColor: Colors.blue,
//         child: const Icon(Icons.add),
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => JournalEditBlocProvider(
//                 journalEditBloc: JournalEditBloc(),
//                 child: EditEntryAdd(),
//               ),
//             ),
//           ).then((value) {
//             if (value == true) {
//               _loadJournalEntries();
//             }
//           });
//         },
//       ),
//       bottomNavigationBar: BottomAppBar(
//         shape: const CircularNotchedRectangle(),
//         notchMargin: 8.0,
//         child: Container(
//           height: 60.0,
//           color: Colors.blue,
//         ),
//       ),
//     );
//   }

//   Future<bool> _showDeleteConfirmationDialog(int index) async {
//     bool? deleteConfirmed = await showDialog<bool>(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text("Delete Journal"),
//           content:
//               const Text("Are you sure you want to delete this journal entry?"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(false);
//               },
//               child: const Text('Cancel'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(true);
//               },
//               child: const Text('Delete'),
//             ),
//           ],
//         );
//       },
//     );

//     if (deleteConfirmed == true) {
//       await _deleteJournalEntry(index);
//     }

//     return deleteConfirmed == true;
//   }
// }

// Container _buildCompleteTrip() {
//   return Container(
//     color: Colors.red,
//     child: const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.start,
//         children: <Widget>[
//           Icon(
//             Icons.done,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     ),
//   );
// }

// Container _buildRemoveTrip() {
//   return Container(
//     color: Colors.green,
//     child: const Padding(
//       padding: EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.end,
//         children: <Widget>[
//           Icon(
//             Icons.delete,
//             color: Colors.white,
//           ),
//         ],
//       ),
//     ),
//   );
// }
