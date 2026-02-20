enum PdfSectionType { text, bullet, score, image }

class PdfSection {
  final String title;
  final String content;
  final List<String>? bulletPoints;
  final double? score;
  final PdfSectionType type;

  PdfSection({
    required this.title,
    required this.content,
    this.bulletPoints,
    this.score,
    this.type = PdfSectionType.text,
  });
}
