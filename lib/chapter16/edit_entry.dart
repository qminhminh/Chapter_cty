// ignore_for_file: no_leading_underscores_for_local_identifiers, use_build_context_synchronously, avoid_print, use_key_in_widget_constructors, library_private_types_in_public_api, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Sử dụng Firestore để lưu dữ liệu
import 'package:tuhoc_cty/chapter16/format_dates.dart'; // Định dạng ngày tháng
import 'package:tuhoc_cty/chapter16/journal_edit_bloc.dart'; // Quản lý BLoC
import 'package:tuhoc_cty/chapter16/journal_edit_bloc_provider.dart'; // Cung cấp BLoC cho widget
import 'package:tuhoc_cty/chapter16/mood_icons.dart'; // Biểu tượng tâm trạng

class EditEntry extends StatefulWidget {
  @override
  _EditEntryState createState() => _EditEntryState();
}

class _EditEntryState extends State<EditEntry> {
  late JournalEditBloc _journalEditBloc;
  late FormatDates _formatDates;
  late MoodIcons _moodIcons;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _formatDates = FormatDates(); // Khởi tạo đối tượng định dạng ngày tháng
    _moodIcons = MoodIcons(); // Khởi tạo đối tượng biểu tượng tâm trạng
    _noteController =
        TextEditingController(); // Controller để lấy nội dung ghi chú
    _noteController.text = ''; // Đặt giá trị ban đầu là chuỗi rỗng
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final JournalEditBlocProvider? provider =
        JournalEditBlocProvider.of(context);
    if (provider == null) {
      // Xử lý lỗi khi không tìm thấy provider
      throw StateError(
          'JournalEditBlocProvider không tìm thấy trong cây widget.');
    }
    _journalEditBloc =
        provider.journalEditBloc; // Lấy journalEditBloc từ provider
  }

  @override
  void dispose() {
    _noteController.dispose(); // Giải phóng controller khi không cần dùng
    _journalEditBloc.dispose(); // Giải phóng BLoC
    super.dispose();
  }

  Future<String> _selectDate(String selectedDate) async {
    DateTime _initialDate =
        DateTime.parse(selectedDate); // Chuyển chuỗi thành đối tượng DateTime
    final DateTime? _pickedDate = await showDatePicker(
      context: context,
      initialDate: _initialDate,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (_pickedDate != null) {
      // Cập nhật giá trị ngày tháng khi người dùng chọn
      selectedDate = DateTime(
        _pickedDate.year,
        _pickedDate.month,
        _pickedDate.day,
        _initialDate.hour,
        _initialDate.minute,
        _initialDate.second,
        _initialDate.millisecond,
        _initialDate.microsecond,
      ).toString();
    }
    return selectedDate; // Trả về chuỗi ngày tháng đã chọn
  }

  void _addOrUpdateJournal() async {
    try {
      // Lấy dữ liệu từ stream dateEdit
      String? date = await _journalEditBloc.dateEdit.first;
      String? mood = await _journalEditBloc.moodEdit.first;
      String note = _noteController.text;

      if (date == null || mood == null) {
        print("Date hoặc mood chưa có giá trị");
        return;
      }

      // Thêm dữ liệu vào Firestore
      CollectionReference journals =
          FirebaseFirestore.instance.collection('journals');
      journals
          .add({
            'date': date,
            'mood': mood,
            'note': note,
          })
          .then(
              (value) => print("Đã thêm nhật ký")) // Thêm dữ liệu vào Firestore
          .catchError((error) =>
              print("Không thể thêm nhật ký: $error")); // Xử lý lỗi khi thêm

      // Cập nhật trạng thái đã lưu
      _journalEditBloc.saveJournalChanged.add('Save');
      Navigator.pop(context); // Đóng màn hình sau khi lưu
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Entry',
          style: TextStyle(color: Colors.lightGreen.shade800),
        ),
        automaticallyImplyLeading: false,
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
      ),
      body: SafeArea(
        minimum: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Date Picker: Cho phép chọn ngày
              StreamBuilder<String>(
                stream: _journalEditBloc.dateEdit,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  // Giá trị mặc định khi dữ liệu là null
                  String date = snapshot.data ??
                      '2024-01-01'; // Bạn có thể thay đổi giá trị mặc định này theo ý muốn

                  return TextButton(
                    onPressed: () async {
                      FocusScope.of(context).requestFocus(FocusNode());
                      String _pickerDate = await _selectDate(
                          date); // Sử dụng giá trị date, không phải snapshot.data!
                      _journalEditBloc.dateEditChanged
                          .add(_pickerDate); // Thay đổi giá trị ngày trong BLoC
                    },
                    child: Row(
                      children: <Widget>[
                        const Icon(
                          Icons.calendar_today,
                          size: 22.0,
                          color: Colors.black54,
                        ),
                        const SizedBox(width: 16.0),
                        Text(
                          _formatDates.dateFormatShortMonthDayYear(
                              date), // Sử dụng giá trị date, không phải snapshot.data!
                          style: const TextStyle(
                            color: Colors.black54,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Icon(
                          Icons.arrow_drop_down,
                          color: Colors.black54,
                        ),
                      ],
                    ),
                  );
                },
              ),

              // Mood Picker: Cho phép chọn tâm trạng
              StreamBuilder<String>(
                stream: _journalEditBloc.moodEdit,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  // Giá trị mặc định khi không có dữ liệu
                  String mood = snapshot.data ?? 'Very Satisfied';

                  // Tìm MoodIcon phù hợp với giá trị mood
                  List<MoodIcon> moodIconsList = _moodIcons.getMoodIconsList();
                  MoodIcon selectedMoodIcon = moodIconsList.firstWhere(
                    (icon) => icon.title == mood,
                    orElse: () => MoodIcon(
                      title: 'Very Satisfied',
                      icon: Icons.sentiment_very_satisfied,
                      color: Colors.green,
                      rotation: 0.0,
                    ),
                  );

                  // Kiểm tra xem selectedMoodIcon có trong danh sách items không
                  bool isValidValue =
                      moodIconsList.any((icon) => icon.title == mood);

                  return DropdownButtonHideUnderline(
                    child: DropdownButton<MoodIcon>(
                      value: isValidValue ? selectedMoodIcon : null,
                      onChanged: (MoodIcon? selected) {
                        if (selected != null) {
                          _journalEditBloc.moodEditChanged
                              .add(selected.title); // Cập nhật mood
                        }
                      },
                      items: moodIconsList.map((MoodIcon mood) {
                        return DropdownMenuItem<MoodIcon>(
                          value: mood,
                          child: Row(
                            children: <Widget>[
                              Transform(
                                transform: Matrix4.identity()
                                  ..rotateZ(mood.rotation), // Xoay biểu tượng
                                alignment: Alignment.center,
                                child: Icon(
                                  mood.icon,
                                  color: mood.color,
                                ),
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

              // TextField cho ghi chú
              StreamBuilder<String>(
                stream: _journalEditBloc.noteEdit,
                builder:
                    (BuildContext context, AsyncSnapshot<String> snapshot) {
                  // Kiểm tra nếu snapshot.data là null thì đặt giá trị mặc định
                  _noteController.value = _noteController.value.copyWith(
                    text: snapshot.data ??
                        '', // Nếu snapshot.data là null thì đặt giá trị rỗng
                  );
                  return TextField(
                    controller: _noteController,
                    textInputAction: TextInputAction.newline,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(
                      labelText: 'Note',
                      icon: Icon(Icons.subject),
                    ),
                    maxLines: null, // Cho phép nhiều dòng
                    onChanged: (note) => _journalEditBloc.noteEditChanged
                        .add(note), // Thay đổi ghi chú
                  );
                },
              ),

              // Nút Cancel và Save
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
                    onPressed: () {
                      _addOrUpdateJournal(); // Lưu nhật ký
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
