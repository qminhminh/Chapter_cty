// // ignore_for_file: use_build_context_synchronously, avoid_print, library_private_types_in_public_api, prefer_const_constructors_in_immutables, use_key_in_widget_constructors, prefer_const_constructors

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:tuhoc_cty/chapter16/format_dates.dart';
// import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart';
// import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart';
// import 'package:tuhoc_cty/chapter16/mood_icons.dart';

// class EditEntry extends StatefulWidget {
//   final String entryId;
//   final DateTime date;
//   final String note;
//   final String mood;

//   EditEntry({
//     required this.entryId,
//     required this.date,
//     required this.note,
//     required this.mood,
//   });

//   @override
//   _EditEntryState createState() => _EditEntryState();
// }

// class _EditEntryState extends State<EditEntry> {
//   late JournalEditBloc _journalEditBloc;
//   late FormatDates _formatDates;
//   late MoodIcons _moodIcons;
//   late TextEditingController _noteController;

//   @override
//   void initState() {
//     super.initState();
//     _formatDates = FormatDates();
//     _moodIcons = MoodIcons();
//     _noteController = TextEditingController(text: widget.note);
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     final JournalEditBlocProvider? provider =
//         JournalEditBlocProvider.of(context);
//     if (provider == null) {
//       throw StateError('JournalEditBlocProvider not found in widget tree.');
//     }
//     _journalEditBloc = provider.journalEditBloc;
//     _journalEditBloc.initialize();
//   }

//   @override
//   void dispose() {
//     _noteController.dispose();
//     _journalEditBloc.dispose();
//     super.dispose();
//   }

//   Future<String> _selectDate(String selectedDate) async {
//     DateTime initialDate = DateTime.parse(selectedDate);
//     final DateTime? pickedDate = await showDatePicker(
//       context: context,
//       initialDate: initialDate,
//       firstDate: DateTime.now().subtract(const Duration(days: 365)),
//       lastDate: DateTime.now().add(const Duration(days: 365)),
//     );
//     if (pickedDate != null) {
//       return DateTime(
//         pickedDate.year,
//         pickedDate.month,
//         pickedDate.day,
//         initialDate.hour,
//         initialDate.minute,
//         initialDate.second,
//         initialDate.millisecond,
//         initialDate.microsecond,
//       ).toString();
//     }
//     return selectedDate;
//   }

//   Future<void> _updateJournal() async {
//     try {
//       String note = _noteController.text;
//       String date = _journalEditBloc.currentDate;
//       String mood = _journalEditBloc.currentMood;
//       DateTime dateTime = DateTime.parse(date);

//       SharedPreferences prefs = await SharedPreferences.getInstance();
//       String? savedJournals = prefs.getString('journals');
//       List<Map<String, dynamic>> journalList = savedJournals != null
//           ? List<Map<String, dynamic>>.from(json.decode(savedJournals))
//           : [];

//       // Find the journal entry by ID and update it
//       for (int i = 0; i < journalList.length; i++) {
//         if (journalList[i]['id'] == widget.entryId) {
//           // Use widget.entryId here
//           journalList[i]['date'] = dateTime.toIso8601String();
//           journalList[i]['mood'] = mood;
//           journalList[i]['note'] = note;
//           break; // Exit the loop after updating
//         }
//       }

//       await prefs.setString('journals', json.encode(journalList));
//       _showSuccessDialog("Entry updated successfully");
//     } catch (e) {
//       print('Error: $e');
//     }
//   }

//   void _showSuccessDialog(String note) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: const Text('Success'),
//           content: Text('Journal entry saved: $note'),
//           actions: <Widget>[
//             TextButton(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.pop(context); // Đóng dialog
//                 Navigator.pop(context, true); // Quay lại màn hình trước
//               },
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title:
//             Text('Entry', style: TextStyle(color: Colors.lightGreen.shade800)),
//         automaticallyImplyLeading: false,
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
//       ),
//       body: Container(
//         color: Color.fromARGB(255, 127, 196, 249),
//         child: SafeArea(
//           minimum: const EdgeInsets.all(16.0),
//           child: SingleChildScrollView(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 StreamBuilder<String>(
//                   stream: _journalEditBloc.dateEdit,
//                   builder:
//                       (BuildContext context, AsyncSnapshot<String> snapshot) {
//                     String date = snapshot.data ?? widget.date.toString();
//                     return TextButton(
//                       onPressed: () async {
//                         FocusScope.of(context).requestFocus(FocusNode());
//                         String pickedDate = await _selectDate(date);
//                         _journalEditBloc.dateEditChanged.add(pickedDate);
//                       },
//                       child: Row(
//                         children: <Widget>[
//                           const Icon(Icons.calendar_today,
//                               size: 22.0, color: Colors.black54),
//                           const SizedBox(width: 16.0),
//                           Text(
//                             _formatDates.dateTimeFormat(DateTime.parse(date)),
//                             style: const TextStyle(
//                                 color: Colors.black54,
//                                 fontWeight: FontWeight.bold),
//                           ),
//                           const Icon(Icons.arrow_drop_down,
//                               color: Colors.black54),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//                 StreamBuilder<String>(
//                   stream: _journalEditBloc.moodEdit,
//                   builder:
//                       (BuildContext context, AsyncSnapshot<String> snapshot) {
//                     String mood = snapshot.data ?? widget.mood;
//                     List<MoodIcon> moodIconsList =
//                         _moodIcons.getMoodIconsList();
//                     MoodIcon selectedMoodIcon = moodIconsList.firstWhere(
//                       (icon) => icon.title == mood,
//                       orElse: () => MoodIcon(
//                         title: 'Very Satisfied',
//                         icon: Icons.sentiment_very_satisfied,
//                         color: Colors.blue,
//                         rotation: 0.0,
//                       ),
//                     );
//                     bool isValidValue =
//                         moodIconsList.any((icon) => icon.title == mood);
//                     return DropdownButtonHideUnderline(
//                       child: DropdownButton<MoodIcon>(
//                         value: isValidValue ? selectedMoodIcon : null,
//                         onChanged: (MoodIcon? selected) {
//                           if (selected != null) {
//                             _journalEditBloc.moodEditChanged
//                                 .add(selected.title);
//                           }
//                         },
//                         items: moodIconsList.map((MoodIcon mood) {
//                           return DropdownMenuItem<MoodIcon>(
//                             value: mood,
//                             child: Row(
//                               children: <Widget>[
//                                 Transform(
//                                   transform: Matrix4.identity()
//                                     ..rotateZ(mood.rotation),
//                                   alignment: Alignment.center,
//                                   child: Icon(mood.icon, color: mood.color),
//                                 ),
//                                 const SizedBox(width: 16.0),
//                                 Text(mood.title),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       ),
//                     );
//                   },
//                 ),
//                 StreamBuilder<String>(
//                   stream: _journalEditBloc.noteEdit,
//                   builder:
//                       (BuildContext context, AsyncSnapshot<String> snapshot) {
//                     _noteController.value = _noteController.value.copyWith(
//                       text: snapshot.data ?? widget.note,
//                     );
//                     return TextField(
//                       controller: _noteController,
//                       textInputAction: TextInputAction.newline,
//                       textCapitalization: TextCapitalization.sentences,
//                       decoration: const InputDecoration(
//                         labelText: 'Note',
//                         icon: Icon(Icons.subject),
//                       ),
//                       maxLines: null,
//                       onChanged: (note) =>
//                           _journalEditBloc.noteEditChanged.add(note),
//                     );
//                   },
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: <Widget>[
//                     TextButton(
//                       child: const Text('Cancel'),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                     const SizedBox(width: 8.0),
//                     TextButton(
//                       child: const Text('Save'),
//                       onPressed: () async {
//                         await _updateJournal();
//                       },
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
