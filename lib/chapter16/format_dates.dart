import 'package:intl/intl.dart';

class FormatDates {
  // Format for displaying date and time
  String dateTimeFormat(DateTime dateTime) {
    return DateFormat('MMM dd, yyyy HH:mm')
        .format(dateTime); // Example format: Sep 14, 2024 15:30
  }
}
