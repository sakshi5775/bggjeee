import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/common_pdf_loading_widget.dart';
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
    String languageCode = 'en',
  }) async {
    try {
      // 1. Show loading state
      Get.dialog(const CommonPdfLoadingWidget(), barrierDismissible: false);

      // 2. Generate bytes with timeout
      final pdfBytes = await buildPdfBytes(
        title: title,
        sections: sections,
        metadata: metadata,
        languageCode: languageCode,
      ).timeout(const Duration(seconds: 45)); // Increased for translation

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
      debugPrint("PDF Generation Error: $e");

      String message =
          "The report is ready but taking a moment to load. Please try again.";
      if (e is TimeoutException) {
        message =
            "PDF generation timed out. Please check your connection and try again.";
      } else {
        message = "Error generating PDF: $e";
      }

      Get.snackbar(
        "Notice",
        message,
        backgroundColor: "#6F221E".toColor().withOpacity(0.8),
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 5),
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
    String languageCode = 'en',
  }) async {
    final pdf = pw.Document();
    final stopwatch = Stopwatch()..start();

    // 1. Initial Asset Loading (Parallel with first translation if needed)
    debugPrint("PDF: Starting asset loading...");
    final assetFutures = Future.wait([
      _loadLogo(),
      _loadBrandingSvg(),
      _loadFont('assets/fonts/Poppins-Regular.ttf', fontName: 'Poppins'),
      _loadFont('assets/fonts/Baloo2-Bold.ttf', fontName: 'Baloo2'),
    ]);

    String translatedTitle = title;
    List<PdfSection> finalSections = sections;

    /*
    // 2. Conditional Translation (Short-circuit for English)
    if (languageCode != 'en') {
      debugPrint("PDF: Language is $languageCode, starting translation...");
      final translationService = MLKitTranslationServiceV2();

      // Translate Title
      translatedTitle = await translationService.translateText(
        text: title,
        sourceLanguageCode: 'en',
        targetLanguageCode: languageCode,
      );

      // Prepare all unique strings to translate
      final List<Future<String>> sectionTitleFutures = [];
      final List<Future<String>> sectionContentFutures = [];
      final List<List<Future<String>>> sectionBulletsFutures = [];

      for (var section in sections) {
        sectionTitleFutures.add(
          translationService.translateText(
            text: section.title,
            sourceLanguageCode: 'en',
            targetLanguageCode: languageCode,
          ),
        );

        if (section.type == PdfSectionType.bullet &&
            section.bulletPoints != null) {
          sectionContentFutures.add(Future.value("")); // Placeholder
          final List<Future<String>> bullets = [];
          for (var point in section.bulletPoints!) {
            bullets.add(
              translationService.translateText(
                text: point,
                sourceLanguageCode: 'en',
                targetLanguageCode: languageCode,
              ),
            );
          }
          sectionBulletsFutures.add(bullets);
        } else {
          sectionContentFutures.add(
            translationService.translateText(
              text: section.content,
              sourceLanguageCode: 'en',
              targetLanguageCode: languageCode,
            ),
          );
          sectionBulletsFutures.add([]);
        }
      }

      // Resolve all translation futures in parallel
      final results = await Future.wait([
        Future.wait(sectionTitleFutures),
        Future.wait(sectionContentFutures),
        Future.wait(sectionBulletsFutures.map((group) => Future.wait(group))),
      ]);

      final List<String> translatedSectionTitles = results[0] as List<String>;
      final List<String> translatedSectionContents = results[1] as List<String>;
      final List<List<String>> translatedSectionBullets =
          results[2] as List<List<String>>;

      finalSections = [];
      for (int i = 0; i < sections.length; i++) {
        finalSections.add(
          PdfSection(
            title: _cleanText(translatedSectionTitles[i]),
            content: _cleanText(translatedSectionContents[i]),
            bulletPoints: translatedSectionBullets[i].map(_cleanText).toList(),
            score: sections[i].score,
            type: sections[i].type,
          ),
        );
      }
      debugPrint(
        "PDF: Translation completed in ${stopwatch.elapsedMilliseconds}ms",
      );
    } else {
      debugPrint("PDF: Language is English, skipping translation.");
    }
    */
    debugPrint("PDF: Translation disabled. Using English content.");

    // 3. Wait for assets to finish loading
    final assets = await assetFutures;
    final pw.ImageProvider? logoImage = assets[0] as pw.ImageProvider?;
    final String brandingSvg = assets[1] as String;
    final pw.Font poppinsRegular = assets[2] as pw.Font;
    final pw.Font balooBold = assets[3] as pw.Font;
    debugPrint("PDF: Assets loaded in ${stopwatch.elapsedMilliseconds}ms");

    // 4. Determine Theme Configuration (Scaling & Fonts)
    final theme = _getThemeConfig(
      languageCode: languageCode,
      poppins: poppinsRegular,
      baloo: balooBold,
    );

    final baseStyle = pw.TextStyle(
      font: theme.baseFont,
      fontSize: theme.baseFontSize - 2,
      color: PdfColors.black,
    );

    final contentStyle = pw.TextStyle(
      font: theme.baseFont,
      fontSize: theme.baseFontSize,
      lineSpacing: theme.lineHeight * 1.5,
      color: PdfColors.grey900,
    );

    final subheadingStyle = pw.TextStyle(
      font: theme.boldFont,
      fontSize: theme.subheadingSize,
      fontWeight: pw.FontWeight.bold,
      color: maroon,
    );

    // 5. Build PDF structure
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        theme: pw.ThemeData.withFont(
          base: theme.baseFont,
          bold: theme.boldFont,
        ),
        header: (context) => _buildHeader(
          context,
          translatedTitle,
          logoImage,
          brandingSvg,
          metadata,
          subheadingStyle,
          baseStyle,
        ),
        footer: (context) => _buildFooter(context, metadata, baseStyle),
        build: (context) => [
          pw.SizedBox(height: 20),
          ...finalSections.asMap().entries.map((entry) {
            final index = entry.key;
            final section = entry.value;
            debugPrint("PDF: Rendering section $index: ${section.title}");
            return _buildSection(section, subheadingStyle, contentStyle);
          }),
        ],
      ),
    );

    debugPrint("PDF: Structure built in ${stopwatch.elapsedMilliseconds}ms");
    try {
      final bytes = await pdf.save();
      debugPrint(
        "PDF: Total generation time: ${stopwatch.elapsedMilliseconds}ms",
      );
      return bytes;
    } catch (e) {
      debugPrint("PDF: ERROR DURING SAVE: $e");
      if (e is AssertionError) {
        debugPrint("PDF: Assertion failed at ${e.stackTrace}");
      }
      rethrow;
    }
  }

  static pw.Widget _buildHeader(
    pw.Context context,
    String title,
    pw.ImageProvider? logo,
    String brandingSvg,
    PdfMetadata metadata,
    pw.TextStyle titleStyle,
    pw.TextStyle subStyle,
  ) {
    final dateStr = DateFormat('dd MMM yyyy').format(metadata.generatedAt);

    return pw.Column(
      children: [
        pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Row(
              children: [
                if (logo != null)
                  pw.Container(
                    width: 40,
                    height: 40,
                    child: pw.Image(logo), // Fetched from AppConstant.logo
                  ),
                pw.SizedBox(width: 8),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    if (brandingSvg.trim().startsWith('<svg') &&
                        brandingSvg.contains('viewBox'))
                      pw.SvgImage(svg: brandingSvg, width: 100, height: 24)
                    else
                      pw.Text(
                        "AstroBharatAI",
                        style: pw.TextStyle(
                          font: titleStyle.font,
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: maroon,
                        ),
                      ),
                    pw.Text(
                      "STARS ALIGN DESTINY DIVINE",
                      style: pw.TextStyle(
                        fontSize: 7,
                        fontWeight: pw.FontWeight.bold,
                        color: maroon,
                        letterSpacing: 1.2,
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
                    "Name: ${metadata.userName}",
                    style: subStyle.copyWith(
                      fontSize: 8,
                      color: PdfColors.grey700,
                    ),
                  ),
                pw.Text(
                  "Date: $dateStr",
                  style: subStyle.copyWith(
                    fontSize: 8,
                    color: PdfColors.grey700,
                  ),
                ),
              ],
            ),
          ],
        ),
        pw.SizedBox(height: 12),
        pw.Divider(color: maroon, thickness: 1),
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
    pw.TextStyle headingStyle,
    pw.TextStyle contentStyle,
  ) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 16),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Row(
                children: [
                  pw.Container(
                    width: 3,
                    height: 14,
                    decoration: pw.BoxDecoration(
                      color: orange,
                      borderRadius: pw.BorderRadius.circular(2),
                    ),
                  ),
                  pw.SizedBox(width: 8),
                  pw.Text(section.title, style: headingStyle),
                ],
              ),
              if (section.score != null &&
                  !section.score!.isNaN &&
                  !section.score!.isInfinite)
                pw.Text(
                  "Score: ${section.score!.toStringAsFixed(0)}/100",
                  style: headingStyle.copyWith(fontSize: 10, color: orange),
                ),
            ],
          ),
          pw.SizedBox(height: 10),
          if (section.content.isNotEmpty)
            pw.Padding(
              padding: const pw.EdgeInsets.only(left: 11, bottom: 8),
              child: _buildRichText(
                section.content,
                contentStyle,
                headingStyle,
              ),
            ),
          if (section.type == PdfSectionType.bullet &&
              section.bulletPoints != null)
            ...section.bulletPoints!.map(
              (point) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6, left: 11),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 4, right: 8),
                      child: pw.Container(
                        width: 3,
                        height: 3,
                        decoration: const pw.BoxDecoration(
                          color: PdfColors.grey700,
                          shape: pw.BoxShape.circle,
                        ),
                      ),
                    ),
                    pw.Expanded(child: pw.Text(point, style: contentStyle)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  static pw.Widget _buildRichText(
    String content,
    pw.TextStyle baseStyle,
    pw.TextStyle headerStyle,
  ) {
    final List<pw.Widget> children = [];
    final lines = content.split('\n');

    for (var line in lines) {
      final trimmed = line.trim();
      if (trimmed.isEmpty) {
        children.add(pw.SizedBox(height: 4));
        continue;
      }

      // Check for hierarchy
      if (trimmed.startsWith('###')) {
        children.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 6, bottom: 2),
            child: pw.Text(
              trimmed.replaceFirst('###', '').trim(),
              style: headerStyle.copyWith(fontSize: 9),
            ),
          ),
        );
      } else if (trimmed.startsWith('##')) {
        children.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 8, bottom: 4),
            child: pw.Text(
              trimmed.replaceFirst('##', '').trim(),
              style: headerStyle.copyWith(fontSize: 10),
            ),
          ),
        );
      } else if (trimmed.startsWith('#')) {
        children.add(
          pw.Padding(
            padding: const pw.EdgeInsets.only(top: 10, bottom: 6),
            child: pw.Text(
              trimmed.replaceFirst('#', '').trim(),
              style: headerStyle.copyWith(fontSize: 11),
            ),
          ),
        );
      } else {
        children.add(
          pw.Text(trimmed, style: baseStyle, textAlign: pw.TextAlign.left),
        );
      }
    }

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: children,
    );
  }

  static Future<String> _loadBrandingSvg() async {
    try {
      debugPrint("PDF: Fetching network branding SVG...");
      final bytes = await _fetchNetworkLogo(AppConstant.logoText);
      if (bytes != null && bytes.isNotEmpty) {
        final svgContent = utf8.decode(bytes);
        if (svgContent.trim().startsWith('<svg')) {
          return svgContent;
        }
      }
    } catch (e) {
      debugPrint("PDF: Error fetching network branding SVG: $e");
    }
    // Fallback to local asset
    return rootBundle.loadString(AppConstant.astroBharatLogo);
  }

  static Future<pw.ImageProvider?> _loadLogo() async {
    if (_logo != null) return _logo!;
    try {
      // Fetch network logo
      final Uint8List? networkBytes = await _fetchNetworkLogo(AppConstant.logo);
      if (networkBytes != null && networkBytes.isNotEmpty) {
        if (_isValidPdfImage(networkBytes)) {
          try {
            _logo = pw.MemoryImage(networkBytes);
            return _logo!;
          } catch (e) {
            debugPrint(
              "PDF: Failed to create MemoryImage from network logo: $e",
            );
          }
        } else {
          debugPrint(
            "PDF: Network logo format is NOT supported (likely ICO). Skipping.",
          );
        }
      }

      // Fallback 1: assets/app/logo.png (User Specified)
      final bytes = await rootBundle.load('assets/app/logo.png');
      final byteData = bytes.buffer.asUint8List();
      if (byteData.isNotEmpty && _isValidPdfImage(byteData)) {
        _logo = pw.MemoryImage(byteData);
        return _logo!;
      }

      // Fallback 2: assets/images/logo.png
      final bytes2 = await rootBundle.load('assets/images/logo.png');
      final byteData2 = bytes2.buffer.asUint8List();
      if (byteData2.isNotEmpty && _isValidPdfImage(byteData2)) {
        _logo = pw.MemoryImage(byteData2);
        return _logo!;
      }
    } catch (e) {
      debugPrint("PDF: Logo loading failed: $e");
    }
    // Return null instead of 0-byte image to prevent NaN error in pdf package
    return null;
  }

  static bool _isValidPdfImage(Uint8List bytes) {
    if (bytes.length < 4) return false;
    // PNG: 89 50 4E 47
    if (bytes[0] == 0x89 &&
        bytes[1] == 0x50 &&
        bytes[2] == 0x4E &&
        bytes[3] == 0x47) {
      return true;
    }
    // JPEG: FF D8 FF
    if (bytes[0] == 0xFF && bytes[1] == 0xD8 && bytes[2] == 0xFF) {
      return true;
    }
    return false;
  }

  static Future<Uint8List?> _fetchNetworkLogo(String url) async {
    try {
      final HttpClient client = HttpClient();
      final HttpClientRequest request = await client.getUrl(Uri.parse(url));
      final HttpClientResponse response = await request.close().timeout(
        const Duration(seconds: 10),
      );
      if (response.statusCode == 200) {
        final List<int> bytes = await response.fold<List<int>>(
          [],
          (p, e) => p..addAll(e),
        );
        return Uint8List.fromList(bytes);
      }
    } catch (e) {
      debugPrint("PDF: Error fetching network logo: $e");
    }
    return null;
  }

  static Future<pw.Font> _loadFont(String path, {String? fontName}) async {
    if (fontName == 'Baloo2' && _balooBold != null) return _balooBold!;
    if (fontName == 'Poppins' && _poppinsRegular != null)
      return _poppinsRegular!;

    final fontData = await rootBundle.load(path);
    final font = pw.Font.ttf(fontData);

    if (fontName == 'Baloo2') {
      _balooBold = font;
    } else if (fontName == 'Poppins') {
      _poppinsRegular = font;
    }
    return font;
  }

  // --- Dynamic Styling Configuration (Reusable & Scalable) ---

  static _PdfThemeConfig _getThemeConfig({
    required String languageCode,
    required pw.Font poppins,
    required pw.Font baloo,
  }) {
    final isHindiOrDevanagari = [
      'hi',
      'mr',
      'sa',
      'ne',
      'mai',
      'kok',
      'doi',
    ].contains(languageCode);

    if (isHindiOrDevanagari) {
      return _PdfThemeConfig(
        baseFont: baloo,
        boldFont: baloo,
        baseFontSize: 11.5, // Increased for visual weight parity
        subheadingSize: 14.0,
        lineHeight: 1.25,
      );
    }

    // Default (English/Latin)
    return _PdfThemeConfig(
      baseFont: poppins,
      boldFont: baloo, // Use baloo for headlines even in English for branding
      baseFontSize: 10.0,
      subheadingSize: 12.0,
      lineHeight: 1.15,
    );
  }
}

class _PdfThemeConfig {
  final pw.Font baseFont;
  final pw.Font boldFont;
  final double baseFontSize;
  final double subheadingSize;
  final double lineHeight;

  _PdfThemeConfig({
    required this.baseFont,
    required this.boldFont,
    required this.baseFontSize,
    required this.subheadingSize,
    required this.lineHeight,
  });
}
