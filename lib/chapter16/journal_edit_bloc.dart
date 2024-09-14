import 'dart:async';

class JournalEditBloc {
  // Define controllers and streams for editing
  final _dateEditController = StreamController<String>();
  Stream<String> get dateEdit => _dateEditController.stream;
  Sink<String> get dateEditChanged => _dateEditController.sink;

  final _moodEditController = StreamController<String>();
  Stream<String> get moodEdit => _moodEditController.stream;
  Sink<String> get moodEditChanged => _moodEditController.sink;

  final _noteEditController = StreamController<String>();
  Stream<String> get noteEdit => _noteEditController.stream;
  Sink<String> get noteEditChanged => _noteEditController.sink;

  // Save Journal stream (You already have this one)
  final _saveJournalController = StreamController<String>();
  Stream<String> get saveJournalStream => _saveJournalController.stream;
  Sink<String> get saveJournalChanged => _saveJournalController.sink;

  void dispose() {
    _dateEditController.close();
    _moodEditController.close();
    _noteEditController.close();
    _saveJournalController.close();
  }
}
