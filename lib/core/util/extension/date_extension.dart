import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

extension DateFormation on DateTime {
  String toFullFormate() {
    return DateFormat('dd MMM yyyy, hh:mm a').format(this);
  }

  String todMMMyyyy() {
    return DateFormat('d MMM yyyy').format(this);
  }

  String toMMMMyyyy() {
    return DateFormat('MMMM yyyy').format(this);
  }

  (DateTime, DateTime) get nextWeekend {
    int remainingDays = (DateTime.saturday - weekday) % 7;
    if (remainingDays == 0) remainingDays = 7;
    final nextSaturday = add(Duration(days: remainingDays));

    return (nextSaturday, nextSaturday.add(const Duration(days: 1)));
  }

  DateTime next(int day) {
    int remainingDays = (day - weekday) % 7;
    if (remainingDays == 0) remainingDays = 7;
    return add(Duration(days: remainingDays));
  }

  DateTime after(int days) {
    return add(Duration(days: days));
  }

  bool isBeforeOrEqual(DateTime time) {
    return isSameDay(this, time) || isBefore(time);
  }
}
