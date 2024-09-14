import 'package:intl/intl.dart';

class FormatDates {
  // Format date in a readable format, for example: Jan 01, 2024
  String dateFormatShortMonthDayYear(String date) {
    DateTime parsedDate = DateTime.parse(date);
    return DateFormat.yMMMEd().format(parsedDate);
  }

  // Other formatting methods can be added as needed
}
