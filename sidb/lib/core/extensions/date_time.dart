import 'package:intl/intl.dart';

const datePrintable = 'dd.MM.yyyy';
const dateParsable = 'yyyy-MM-dd';
const timeFormat = 'HH:mm';
const dateTimePrintable = 'dd.MM.yyyy HH:mm';
const dateHeadPrintable = 'dd MMMM';

extension DateTimeExt on DateTime {
  String get printable => DateFormat(datePrintable).format(this);

  String get printableTime => DateFormat(timeFormat).format(this);

  String get parsable => DateFormat(dateParsable).format(this);

  String get printableDateTime => DateFormat(dateTimePrintable).format(this);

  DateTime beginningDay() => DateTime.utc(year, month, day);

  DateTime endDay() => DateTime.utc(year, month, day, 23, 59, 59);

  DateTime beginningMonth() => DateTime.utc(year, month);

  DateTime endMonth() => DateTime.utc(year, month + 1).add(const Duration(days: -1)).beginningDay();

  DateTime get startOfDay {
    return DateTime(year, month, day);
  }
}
