class PassbookItem {
  final String title;
  final String subtitle;
  final String time;
  final String points;
  final String? dateHeader; // Optional date header before this item

  PassbookItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.points,
    this.dateHeader,
  });
}
