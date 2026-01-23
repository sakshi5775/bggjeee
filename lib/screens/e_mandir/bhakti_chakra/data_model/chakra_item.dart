enum ChakraStatus { completed, current, locked }

class ChakraItem {
  final String title;
  final String subtitle;
  final String day;
  final ChakraStatus status;

  ChakraItem({
    required this.title,
    required this.subtitle,
    required this.day,
    required this.status,
  });
}
