enum PdfReportType {
  faceReading,
  palmReading,
  ramal,
  handwriting,
  carrot,
  prashna,
  tarot,
  vastu,
}

class PdfMetadata {
  final String? userName;
  final DateTime generatedAt;
  final String? reportId;
  final PdfReportType reportType;

  PdfMetadata({
    this.userName,
    required this.generatedAt,
    this.reportId,
    required this.reportType,
  });
}
