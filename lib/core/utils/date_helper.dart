import 'dart:math';

class DateHelper {

  static DateTime getRandomDate({
    required DateTime start,
    required DateTime end,
  }) {
    final random = Random();
    final difference = end.difference(start).inDays;
    return start.add(Duration(days: random.nextInt(difference + 1)));
  }

  static List<T> filterByDate<T>({
    DateFilterRange? range,
    required List<T> items,
    required DateTime Function(T entry) filterFn,
  }){
    try {
      DateTime today = DateTime.now();

      switch (range) {
        case null:
          return [];
        case DateFilterRange.today: {
          DateTime startOfToday = DateTime(today.year, today.month,
              today.day); // Get the start of today (00:00:00)
          DateTime endOfToday = DateTime(
              today.year,
              today.month,
              today.day,
              23,
              59,
              59,
              999); // Get the end of today (23:59:59)

          // Filter the data
          return items.where((entry) {
            DateTime entryDate = filterFn(entry);
            return entryDate.isAfter(startOfToday.subtract(const Duration(
                days: 0))) && // Ensure the date is on or after the start of today
                entryDate.isBefore(endOfToday.add(const Duration(
                    days: 1))); // Ensure the date is on or before the end of today
          }).toList();
        }
        case DateFilterRange.thisWeek: {
          final DateTime startOfWeek = today.subtract(Duration(
              days: today.weekday -
                  1)); // Calculate Monday of the current week
          final DateTime endOfWeek = startOfWeek.add(const Duration(
              days: 6)); // Calculate Sunday of the current week

          // Get only the date parts (without the time)
          final DateTime startOfWeekDate = DateTime(
              startOfWeek.year, startOfWeek.month, startOfWeek.day);
          final DateTime endOfWeekDate = DateTime(
              endOfWeek.year, endOfWeek.month, endOfWeek.day);

          return items.where((entry) {
            DateTime entryDate = filterFn(entry);
            return entryDate.isAtSameMomentAs(startOfWeekDate) ||
                entryDate.isAfter(
                    startOfWeekDate.subtract(const Duration(days: 0))) &&
                    entryDate.isBefore(endOfWeekDate.add(
                        const Duration(days: 1))); // Include Sunday
          }).toList();
        }
        case DateFilterRange.thisMonth: {
          DateTime startOfMonth = DateTime(today.year, today.month,
              1); // Get the first day of the current month
          DateTime endOfMonth = DateTime(today.year, today.month + 1,
              0); // Get the last day of the current month

          return items.where((entry) {
            DateTime entryDate = filterFn(entry);
            return entryDate.isAfter(
                startOfMonth.subtract(const Duration(days: 1))) &&
                entryDate.isBefore(endOfMonth.add(
                    const Duration(days: 1))); // Include Sunday
          }).toList();
        }
        case DateFilterRange.thisYear: {
          DateTime startOfYear = DateTime(
              today.year, 1, 1); // Get the first day of the current year
          DateTime endOfYear = DateTime(
              today.year, 12, 31); // Get the last day of the current year

          return items.where((entry) {
            DateTime entryDate = filterFn(entry);
            return entryDate.isAfter(startOfYear.subtract(const Duration(
                days: 1))) && // Ensure the date is on or after the start of the year
                entryDate.isBefore(endOfYear.add(const Duration(
                    days: 1))); // Ensure the date is on or before the end of the year
          }).toList();
        }
      }
    } catch (e){
      rethrow;
    }
  }
}

enum DateFilterRange {
  today("Today"),
  thisWeek("This week"),
  thisMonth("This month"),
  thisYear("This year");
  const DateFilterRange(this.label);
  final String label;
}