class JournalEntry {
  final String id;
  final String date;
  final String mood;
  final String note;

  JournalEntry({
    required this.id,
    required this.date,
    required this.mood,
    required this.note,
  });

  // Convert a JournalEntry into a Map
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'mood': mood,
      'note': note,
    };
  }

  // Convert a Map into a JournalEntry
  factory JournalEntry.fromMap(Map<String, dynamic> map) {
    return JournalEntry(
      id: map['id'],
      date: map['date'],
      mood: map['mood'],
      note: map['note'],
    );
  }
}
