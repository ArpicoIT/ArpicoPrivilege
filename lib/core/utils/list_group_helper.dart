class ListGroupHelper<T> {
  final List<T> items;
  final DateTime? Function(T) dateExtractor; // Function key to extract date

  ListGroupHelper({required this.items, required this.dateExtractor});

  static List<String> groupTitles = [
    "Today",
    "Yesterday",
    "Last 7 Days",
    "Last 30 Days",
    "Last 3 Months",
    "Last 6 Months",
    "Last Year",
    "Older"
  ];

  List<MapEntry<String, List<T>>> groupByDate() {
    final Map<String, List<T>> groupedItems = {
      "Today": [],
      "Yesterday": [],
      "Last 7 Days": [],
      "Last 30 Days": [],
      "Last 3 Months": [],
      "Last 6 Months": [],
      "Last Year": [],
      "Older": [],
    };

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    DateTime yesterday = today.subtract(const Duration(days: 1));
    DateTime last7Days = today.subtract(const Duration(days: 7));
    DateTime last30Days = today.subtract(const Duration(days: 30));
    DateTime last3Months = today.subtract(const Duration(days: 90));
    DateTime last6Months = today.subtract(const Duration(days: 180));
    DateTime lastYear = today.subtract(const Duration(days: 365));

    for (var item in items) {
      DateTime? itemDate = dateExtractor(item);

      if (itemDate == null) {
        groupedItems["Older"]!.add(item);
        continue;
      }

      DateTime itemDateOnly =
          DateTime(itemDate.year, itemDate.month, itemDate.day);

      if (itemDateOnly == today) {
        groupedItems["Today"]!.add(item);
      } else if (itemDateOnly == yesterday) {
        groupedItems["Yesterday"]!.add(item);
      } else if (itemDateOnly.isAfter(last7Days)) {
        groupedItems["Last 7 Days"]!.add(item);
      } else if (itemDateOnly.isAfter(last30Days)) {
        groupedItems["Last 30 Days"]!.add(item);
      } else if (itemDateOnly.isAfter(last3Months)) {
        groupedItems["Last 3 Months"]!.add(item);
      } else if (itemDateOnly.isAfter(last6Months)) {
        groupedItems["Last 6 Months"]!.add(item);
      } else if (itemDateOnly.isAfter(lastYear)) {
        groupedItems["Last Year"]!.add(item);
      } else {
        groupedItems["Older"]!.add(item);
      }
    }

    // Remove empty groups and return as a list of entries
    return groupedItems.entries
        .where((entry) => entry.value.isNotEmpty)
        .toList();
  }
}
