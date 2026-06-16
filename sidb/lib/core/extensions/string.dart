import 'package:jaspr/dom.dart';
import 'package:sidb/core/extensions/date_time.dart';
import 'package:sidb/core/utils/regular_expressions.dart';
import 'package:collection/collection.dart';

extension StringFormat on String {
  String toUpperFirst() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  Color toColor() {
    final hexString = this;
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(buffer.toString());
  }

  int? get toInt => int.tryParse(this) ?? -1;

  double? get toDouble => double.tryParse(this);

  DateTime? get toDate {
    if (contains(regExDate)) {
      final value = split('.');
      try {
        return DateTime(value[2].toInt!, value[1].toInt!, value[0].toInt!);
      } catch (e) {
        return null;
      }
    }
    return DateTime.tryParse(this);
  }

  String get toDateFormat => toDate?.printable ?? '';

  String get toDateTimeFormat => toDate?.printableDateTime ?? '';

  String get toDateParsable => toDate?.parsable ?? '';

  T? toEnumType<T>(List<T> values, [List<String>? prints]) {
    if (prints != null) {
      for (var i = 0; i < values.length; i++) {
        if (prints.elementAt(i).toUpperCase() == toUpperCase()) {
          return values.elementAt(i);
        }
      }
      return null;
    }
    return values.firstWhereOrNull((e) => _enumFormat(e).toUpperCase() == toUpperCase());
  }

  String _enumFormat(value) => value.toString().split('.').last;

  String concatenation(String? addStr, {String? delimiter}) {
    var result = this;
    if (isNotNullOrEmpty && addStr.isNotNullOrEmpty) {
      result += delimiter ?? ', ';
    }
    result += addStr ?? '';
    return result;
  }

  String get nullOrEmptyFormat => isNullOrEmpty ? '-' : this;
}

extension StringNullExt on String? {
  bool get isNotNullOrEmpty => (this ?? '').isNotEmpty;

  bool get isNullOrEmpty => (this ?? '').isEmpty;

  String get nullOrEmptyFormat => isNullOrEmpty ? '-' : this!;
}
