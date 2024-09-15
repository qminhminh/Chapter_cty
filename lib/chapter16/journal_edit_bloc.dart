// Đảm bảo thêm import này cho RxDart
import 'dart:async';
import 'package:rxdart/rxdart.dart';

class JournalEditBloc {
  final _dateEditController =
      BehaviorSubject<String>.seeded(DateTime.now().toString());
  Stream<String> get dateEdit => _dateEditController.stream;
  Sink<String> get dateEditChanged => _dateEditController.sink;

  final _moodEditController = BehaviorSubject<String>.seeded('Very Satisfied');
  Stream<String> get moodEdit => _moodEditController.stream;
  Sink<String> get moodEditChanged => _moodEditController.sink;

  final _noteEditController = StreamController<String>.broadcast();
  Stream<String> get noteEdit => _noteEditController.stream;
  Sink<String> get noteEditChanged => _noteEditController.sink;

  final _saveJournalController = StreamController<String>.broadcast();
  Stream<String> get saveJournalStream => _saveJournalController.stream;
  Sink<String> get saveJournalChanged => _saveJournalController.sink;

  String get currentDate => _dateEditController.value;
  String get currentMood => _moodEditController.value;

  void initialize() {
    // Initialize with default values (handled by BehaviorSubject)
  }

  void dispose() {
    _dateEditController.close();
    _moodEditController.close();
    _noteEditController.close();
    _saveJournalController.close();
  }
}
