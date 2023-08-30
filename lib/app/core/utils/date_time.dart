import 'package:intl/intl.dart';

class DateTimeUtils {
  // date with intl
  static String format(
    DateTime? date, {
    String? format = 'EEEE, dd MMM yyyy',
  }) {
    if (date == null) return '-';
    return DateFormat(format, 'id_ID').format(date);
  }

  /// `hour="08:00:00.000000"`
  static String getTimeRange(String? time, int? duration) {
    if (time == null) return '-';

    final DateTime dateTime = dateTimeFromString(time);

    return '${format(dateTime, format: 'HH:mm')} - ${format(dateTime.add(Duration(minutes: duration ?? 0)), format: 'HH:mm')} WIB';
  }

  static bool isDateToday(DateTime? date) {
    if (date == null) return false;
    final DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .isAtSameMomentAs(DateTime(now.year, now.month, now.day));
  }

  static bool isToday(int weekday) {
    final DateTime now = DateTime.now();
    if (weekday == 0) return now.weekday == 7;
    return now.weekday == weekday;
  }

  static bool isLive(
    String? time,
    int? duration,
    int weekday, [
    int? beforeStartDuration,
  ]) {
    if (time == null) return false;

    final DateTime now = DateTime.now();
    final dateTime = dateTimeFromString(time);

    if (isToday(weekday) &&
        now.isAfter(
          dateTime.subtract(Duration(minutes: beforeStartDuration ?? 0)),
        ) &&
        now.isBefore(dateTime.add(Duration(minutes: duration ?? 0)))) {
      return true;
    }

    return false;
  }

  static bool isUpcoming(
    String? time,
    int? duration,
    int weekday, [
    int? beforeStartDuration,
  ]) {
    if (time == null) return false;

    final DateTime now = DateTime.now();
    final dateTime = dateTimeFromString(time);

    if (isToday(weekday) &&
        now.isBefore(dateTime.add(Duration(minutes: duration ?? 0)))) {
      return true;
    }

    return false;
  }

  static DateTime dateTimeFromString(String time) {
    final DateTime now = DateTime.now();
    return DateTime(
      now.year,
      now.month,
      now.day,
      int.parse(time.split(':')[0]),
      int.parse(time.split(':')[1]),
    );
  }

  static DateTime getPrevMonth(DateTime date) {
    int year = date.year;
    int month = date.month;

    if (month == 1) {
      year--;
      month = 12;
    } else {
      month--;
    }

    return DateTime(year, month, date.day);
  }

  static DateTime getNextMonth(DateTime date) {
    int year = date.year;
    int month = date.month;

    if (month == 12) {
      year++;
      month = 1;
    } else {
      month++;
    }

    return DateTime(year, month, date.day);
  }

  static DateTime getPrevYear(
    DateTime date, {
    DateTime? minDate,
  }) {
    if (minDate != null && date.year <= minDate.year) {
      return DateTime(date.year, date.month, date.day);
    }

    return DateTime(date.year - 1, date.month, date.day);
  }

  static DateTime getNextYear(
    DateTime date, {
    DateTime? maxDate,
  }) {
    if (maxDate != null && date.year >= maxDate.year) {
      return DateTime(date.year, date.month, date.day);
    }

    return DateTime(date.year + 1, date.month, date.day);
  }
}
