import 'dart:io';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart' hide PdfMetadata;
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:open_file/open_file.dart';
import '../../data_model/pdf_metadata.dart';
import '../../data_model/pdf_section.dart';

class PdfGeneratorService {
  static const PdfColor maroon = PdfColor.fromInt(0xFF6F221E);
  static const PdfColor orange = PdfColor.fromInt(0xFFF38B3B);
  static const PdfColor lightOrange = PdfColor.fromInt(0xFFFFF2E8);

  // Static cache for performance
  static pw.Font? _poppinsRegular;
  static pw.Font? _balooBold;
  static pw.MemoryImage? _logo;

  /// Main entry point to generate and show/preview the PDF
  static Future<void> generateAstrologyReport({
    required String title,
    required List<PdfSection> sections,
    required PdfMetadata metadata,
  }) async {
    try {
      // 1. Show loading state
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
      );

      // 2. Generate bytes with timeout
      final pdfBytes = await buildPdfBytes(
        title: title,
        sections: sections,
        metadata: metadata,
      ).timeout(const Duration(seconds: 15));

      // 3. Remove loading logic
      if (Get.isDialogOpen ?? false) Get.back();

      // 4. Navigate to preview screen
      await Get.toNamed(
        AppRoutes.reportPdfView,
        arguments: {
          'bytes': pdfBytes,
          'fileName': _buildFileName(metadata),
          'title': title,
        },
      );
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar(
        "Error",
        "Unable to generate PDF report. Please try again.",
        backgroundColor: Colors.red.withOpacity(0.7),
        colorText: Colors.white,
      );
    }
  }

  static String _buildFileName(PdfMetadata metadata) {
    final user = metadata.userName?.replaceAll(' ', '_') ?? 'User';
    final date = DateFormat('yyyy-MM-dd').format(metadata.generatedAt);
    return 'AstroBharatAI_${metadata.reportType.name}_${user}_$date.pdf';
  }

  /// Saves the PDF to the device based on platform
  static Future<File> downloadPdf({
    required Uint8List pdfBytes,
    required String fileName,
  }) async {
    Directory? directory;
    if (Platform.isAndroid) {
      directory = Directory('/storage/emulated/0/Download');
      if (!await directory.exists()) {
        directory = await getExternalStorageDirectory();
      }
    } else {
      directory = await getApplicationDocumentsDirectory();
    }

    final String filePath = '${directory!.path}/$fileName';
    final File file = File(filePath);
    await file.writeAsBytes(pdfBytes);
    return file;
  }

  /// Builds the PDF and returns bytes
  static Future<Uint8List> buildPdfBytes({
    required String title,
    required List<PdfSection> sections,
    required PdfMetadata metadata,
  }) async {
    final pdf = pw.Document();

    // Load assets with caching
    final logoImage = await _loadLogo();
    final poppinsRegular = await _loadFont(
      'assets/fonts/Poppins-Regular.ttf',
      isHindi: false,
    );
    final balooBold = await _loadFont(
      'assets/fonts/Baloo2-Bold.ttf',
      isHindi: true,
    );

    final baseStyle = pw.TextStyle(font: poppinsRegular, fontSize: 10);
    final hindiStyle = pw.TextStyle(font: balooBold, fontSize: 10);
    final headerStyle = pw.TextStyle(
      font: poppinsRegular,
      fontSize: 18,
      fontWeight: pw.FontWeight.bold,
      color: maroon,
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(base: poppinsRegular, bold: balooBold),
        header: (context) => _buildHeader(
          context,
          title,
          logoImage,
          metadata,
          headerStyle,
          baseStyle,
        ),
        footer: (context) => _buildFooter(context, metadata, baseStyle),
        build: (context) => [
          pw.SizedBox(height: 20),
          ...sections.map(
            (section) => _buildSection(section, baseStyle, hindiStyle),
          ),
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildHeader(
    pw.Context context,
    String title,
    pw.ImageProvider logo,
    PdfMetadata metadata,
    pw.TextStyle titleStyle,
    pw.TextStyle subStyle,
  ) {
    final dateStr = DateFormat('dd MMM yyyy').format(metadata.generatedAt);

    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              children: [
                pw.Container(width: 50, height: 50, child: pw.Image(logo)),
                pw.SizedBox(width: 12),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      "AstroBharatAI",
                      style: titleStyle.copyWith(fontSize: 14),
                    ),
                    pw.Text(
                      "Empowering Your Cosmic Journey",
                      style: subStyle.copyWith(
                        fontSize: 8,
                        color: PdfColors.grey700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                pw.Text(title, style: titleStyle.copyWith(fontSize: 12)),
                if (metadata.userName != null)
                  pw.Text(
                    "User: ${metadata.userName}",
                    style: subStyle.copyWith(fontSize: 9),
                  ),
                pw.Text(
                  "Date: $dateStr",
                  style: subStyle.copyWith(fontSize: 9),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 10),
        pw.Divider(color: maroon, thickness: 1.5),
      ],
    );
  }

  static pw.Widget _buildFooter(
    pw.Context context,
    PdfMetadata metadata,
    pw.TextStyle style,
  ) {
    return pw.Container(
      alignment: pw.Alignment.centerRight,
      margin: const pw.EdgeInsets.only(top: 10),
      child: pw.Column(
        children: [
          pw.Divider(color: PdfColors.grey300),
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    "This report is generated by AstroBharatAI. For personal use only.",
                    style: style.copyWith(
                      fontSize: 7,
                      color: PdfColors.grey600,
                    ),
                  ),
                  if (metadata.reportId != null)
                    pw.Text(
                      "Report ID: ${metadata.reportId}",
                      style: style.copyWith(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.grey700,
                      ),
                    ),
                ],
              ),
              pw.Text(
                'Page ${context.pageNumber} of ${context.pagesCount}',
                style: style.copyWith(fontSize: 8, color: PdfColors.grey600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildSection(
    PdfSection section,
    pw.TextStyle baseStyle,
    pw.TextStyle hindiStyle,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            children: [
              pw.Container(width: 4, height: 14, color: orange),
              pw.SizedBox(width: 8),
              pw.Text(
                section.title,
                style: baseStyle.copyWith(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.bold,
                  color: maroon,
                ),
              ),
              if (section.score != null) ...[
                pw.Spacer(),
                pw.Text(
                  "Score: ${section.score!.toStringAsFixed(0)}/100",
                  style: baseStyle.copyWith(
                    fontSize: 10,
                    fontWeight: pw.FontWeight.bold,
                    color: orange,
                  ),
                ),
              ],
            ],
          ),
          pw.SizedBox(height: 8),

          if (section.type == PdfSectionType.bullet &&
              section.bulletPoints != null)
            ...section.bulletPoints!.map(
              (point) => pw.Row(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Padding(
                    padding: const pw.EdgeInsets.only(top: 4, right: 8),
                    child: pw.Container(
                      width: 3,
                      height: 3,
                      decoration: const pw.BoxDecoration(
                        color: PdfColors.black,
                        shape: pw.BoxShape.circle,
                      ),
                    ),
                  ),
                  pw.Expanded(child: pw.Text(point, style: hindiStyle)),
                ],
              ),
            )
          else
            pw.Text(section.content, style: hindiStyle),

          pw.SizedBox(height: 8),
        ],
      ),
    );
  }

  static Future<pw.ImageProvider> _loadLogo() async {
    if (_logo != null) return _logo!;
    final bytes = await rootBundle.load('assets/images/logo.png');
    _logo = pw.MemoryImage(bytes.buffer.asUint8List());
    return _logo!;
  }

  static Future<pw.Font> _loadFont(String path, {required bool isHindi}) async {
    if (isHindi && _balooBold != null) return _balooBold!;
    if (!isHindi && _poppinsRegular != null) return _poppinsRegular!;

    final fontData = await rootBundle.load(path);
    final font = pw.Font.ttf(fontData);

    if (isHindi) {
      _balooBold = font;
    } else {
      _poppinsRegular = font;
    }
    return font;
  }
}
