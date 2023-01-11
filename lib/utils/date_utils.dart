String getLatestWeekend() {
  final today = DateTime.now();
  DateTime saturday;
  if (today.weekday == 6) {
    saturday = today;
  } else if (today.weekday == 7) {
    saturday = DateTime.fromMillisecondsSinceEpoch(
        today.millisecondsSinceEpoch - 3600 * 24 * 1000);
  } else {
    saturday = DateTime.fromMillisecondsSinceEpoch(
        today.millisecondsSinceEpoch - 3600 * 24 * 1000 * (today.weekday + 1));
  }
  return _fromSaturdayToWeekendString(saturday);
}

String _fromSaturdayToWeekendString(DateTime saturday) {
  final sunday = DateTime.fromMillisecondsSinceEpoch(
      saturday.millisecondsSinceEpoch + 3600 * 24 * 1000);
  if (saturday.month == sunday.month) {
    return '${months[saturday.month - 1]} ${saturday.day} - ${sunday.day}';
  } else {
    return '${months[saturday.month - 1]} ${saturday.day} - ${months[sunday.month - 1]} ${sunday.day}';
  }
}

const List<String> months = [
  'January',
  'February',
  'March',
  'April',
  'May',
  'June',
  'July',
  'August',
  'September',
  'October',
  'November',
  'December',
];

int? monthToInt(String month) {
  for (var i = 0; i < months.length; i++) {
    if (months[i]
        .toLowerCase()
        .startsWith(month.substring(0, 3).toLowerCase())) {
      return i + 1;
    }
  }
  return null;
}
