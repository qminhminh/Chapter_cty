import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class JournalEntry {
  final String id;
  final DateTime date;
  final String note;
  final String mood;

  JournalEntry({
    required this.id,
    required this.date,
    required this.note,
    required this.mood,
  });

  factory JournalEntry.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    final Timestamp timestamp = data['date'];
    final DateTime dateTime = timestamp.toDate();
    return JournalEntry(
      id: doc.id,
      date: dateTime,
      note: data['note'],
      mood: data['mood'],
    );
  }

  String get formattedDate => DateFormat('EEE').format(date);
  String get formattedDay => DateFormat('dd').format(date);
  String get formattedMonthYear => DateFormat('MMM dd, yyyy').format(date);
}
