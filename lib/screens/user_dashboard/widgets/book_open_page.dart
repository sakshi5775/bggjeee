import 'dart:math' as math;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../theme/app_typography.dart';

class BookOpenPage extends StatefulWidget {
  final String title;
  final String imageUrl;

  const BookOpenPage({
    super.key,
    required this.title,
    required this.imageUrl,
  });

  @override
  State<BookOpenPage> createState() => _BookOpenPageState();
}

class _BookOpenPageState extends State<BookOpenPage>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> coverAnim;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    coverAnim = CurvedAnimation(parent: controller, curve: Curves.easeInOut);

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    final data = _bookContent(widget.title);

    return Scaffold(
      body: Stack(
        children: [

          /// BACKGROUND
          Positioned.fill(
            child: Image.asset(
              "assets/app/book_background.png",
              fit: BoxFit.cover,
            ),
          ),

          Positioned.fill(
            child: Container(color: Colors.black.withOpacity(0.25)),
          ),

          /// BOOK
          Center(
            child: AnimatedBuilder(
              animation: controller,
              builder: (_, __) {
                return Stack(
                  alignment: Alignment.center,
                  children: [

                    /// OPEN PAGES
                    Opacity(
                      opacity: coverAnim.value,
                      child: _vedBook(data),
                    ),

                    /// FRONT COVER (FROM CARD IMAGE)
                    if (coverAnim.value < 1)
                      Transform(
                        alignment: Alignment.centerLeft,
                        transform: Matrix4.identity()
                          ..setEntry(3, 2, 0.001)
                          ..rotateY(coverAnim.value * math.pi / 2),
                        child: _bookCover(widget.imageUrl),
                      ),
                  ],
                );
              },
            ),
          ),

          /// BACK
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),
        ],
      ),
    );
  }

  /// ================= FRONT COVER =================
 Widget _bookCover(String imageUrl) {
  final screenWidth = MediaQuery.of(context).size.width;
  final bookWidth = screenWidth * 0.95;
  final bookHeight = bookWidth * 0.65; // same ratio as ved book

  return SizedBox(
    width: bookWidth,
    height: bookHeight,
    child: ClipRRect(
      borderRadius: BorderRadius.circular(28),
      child: CachedNetworkImage(
        imageUrl: imageUrl,
        fit: BoxFit.contain,
      ),
    ),
  );
}


  /// ================= OPEN BOOK =================
  Widget _vedBook(Map<String, String> data) {
  final screenWidth = MediaQuery.of(context).size.width;
  final bookWidth = screenWidth * 0.95;
  final bookHeight = bookWidth * 0.65; // aspect ratio of book image

  return Transform(
    alignment: Alignment.center,
    transform: Matrix4.identity()
      ..setEntry(3, 2, 0.001)
      ..rotateX(-0.05),
    child: SizedBox(
      width: bookWidth,
      height: bookHeight,
      child: Stack(
        children: [

          /// BOOK IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(28),
            child: Image.asset(
              "assets/app/book.png",
              width: bookWidth,
              height: bookHeight,
              fit: BoxFit.contain,
            ),
          ),

          /// LEFT PAGE CONTENT
        Positioned(
  left: bookWidth * 0.16, // moved more right (towards center)
  top: bookHeight * 0.15,
  width: bookWidth * 0.34, // slightly narrower to stay inside page
  height: bookHeight * 0.7,
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(
        data['shloka_title']!,
        textAlign: TextAlign.center,
        style: AppTypography.h3.copyWith(
          fontSize: 16,
          color: const Color(0xFF5A2A00),
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Text(
        data['shloka']!,
        textAlign: TextAlign.center,
        style: AppTypography.h3.copyWith(
          fontSize: 15,
          color: const Color(0xFF5A2A00),
          height: 1.5,
        ),
      ),
    ],
  ),
),


          /// RIGHT PAGE CONTENT
         Positioned(
  right: bookWidth * 0.15, // moved more left (towards center)
  top: bookHeight * 0.15,
  width: bookWidth * 0.34,
  height: bookHeight * 0.7,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        "INTRODUCTION",
        style: AppTypography.h2.copyWith(
          fontSize: 15,
          color: const Color(0xFF4A2400),
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 12),
      Expanded(
        child: SingleChildScrollView(
          child: Text(
            "\"${data['thought']}\"",
            style: AppTypography.body1.copyWith(
              fontSize: 13.5,
              color: const Color(0xFF4A2400),
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ),
      ),
      const SizedBox(height: 12),
      GestureDetector(
        onTap: () => Get.toNamed(AppRoutes.courses),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFF7B1E00),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(.25),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: const Text(
            "READ MORE",
            style: TextStyle(
              fontSize: 12.5,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.8,
            ),
          ),
        ),
      ),
    ],
  ),
),

        ],
      ),
    ),
  );
}


  /// ================= BOOK DATA =================
Map<String, String> _bookContent(String title) {
  switch (title.toLowerCase()) {

    case 'rigveda':
      return {
        'shloka_title': 'Rigveda',
        'shloka': 'अग्निमीळे पुरोहितं यज्ञस्य देवम् ऋत्विजम्।',
        'thought': 'Praise of fire.'
      };

    case 'samveda':
      return {
        'shloka_title': 'Samaveda',
        'shloka': 'आ नो भद्राः क्रतवो यन्तु विश्वतः।',
        'thought': 'Devotion in melody.'
      };

    case 'yajurveda':
      return {
        'shloka_title': 'Yajurveda',
        'shloka': 'इदं विष्णुर्विचक्रमे त्रेधा नदधे पदम्।',
        'thought': 'Sacred ritual path.'
      };

    case 'atharvaveda':
      return {
        'shloka_title': 'Atharvaveda',
        'shloka': 'सर्वं पराधाद्यदि यन्न किंचिद्।',
        'thought': 'Life protection.'
      };

    case 'jyotish vedang':
      return {
        'shloka_title': 'Jyotish Vedang',
        'shloka': 'कालः सृष्टेः प्रधान कारणम्।',
        'thought': 'Cosmic time.'
      };

    default:
      return {
        'shloka_title': 'Vedic Wisdom',
        'shloka': 'सत्यं वद धर्मं चर।',
        'thought': 'Truth and duty.'
      };
  }
}

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
