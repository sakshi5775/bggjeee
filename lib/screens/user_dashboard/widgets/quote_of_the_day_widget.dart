import 'dart:async';

import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/app_manager/network_image.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class QuoteOfTheDayWidget extends BasePage<UserDashboardController> {
  const QuoteOfTheDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quote = controller.dailyQuote.value;
      final isFallback = quote?.isFallback ?? false;
      final title = isFallback ? 'Quote' : 'Quote of the Day';

      return LayoutBuilder(
        builder: (context, constraints) {
          final double screenWidth = constraints.maxWidth;
          final double imageWidth = screenWidth;
          final double imageHeight = (imageWidth * 768) / 990;

          return SizedBox(
            width: imageWidth,
            height: imageHeight,
            child: Stack(
              children: [
                Positioned.fill(
                  child: NetworkImageWithLoader(
                    url: AppConstant.quoteOfTheDay,
                    fit: BoxFit.fitWidth,
                    width: imageWidth,
                  ),
                ),
                Positioned.fill(
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: imageWidth * 0.17,
                      right: imageWidth * 0.17,
                      top: imageHeight * 0.17,
                      bottom: imageHeight * 0.30,
                    ),
                    child: ClipRect(
                      child: _QuoteMarqueeContent(
                        title: title,
                        sanskritText: quote?.sanskrit.text ?? '',
                        meaning: quote?.sanskrit.meaning ?? '',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      );
    });
  }
}

/// Inner stateful widget: upward marquee + manual scroll within image bounds.
class _QuoteMarqueeContent extends StatefulWidget {
  final String title;
  final String sanskritText;
  final String meaning;

  const _QuoteMarqueeContent({
    required this.title,
    required this.sanskritText,
    required this.meaning,
  });

  @override
  State<_QuoteMarqueeContent> createState() => _QuoteMarqueeContentState();
}

class _QuoteMarqueeContentState extends State<_QuoteMarqueeContent> {
  final ScrollController _scrollController = ScrollController();
  Timer? _marqueeTimer; // single timer for auto-scroll; canceled in dispose
  DateTime? _manualScrollPauseUntil;
  VoidCallback? _scrollingNotifierListener;
  bool _disposed = false;

  static const Duration _autoScrollInterval = Duration(milliseconds: 80);
  static const double _autoScrollPixelsPerTick = 0.5;
  static const Duration _pauseAfterManualScroll = Duration(seconds: 4);

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attachScrollListeners();
      _startMarquee();
    });
  }

  void _attachScrollListeners() {
    if (!mounted || !_scrollController.hasClients) return;
    final pos = _scrollController.position;
    void onScrollingChanged() {
      if (!mounted) return;
      setState(() {
        _manualScrollPauseUntil = DateTime.now().add(_pauseAfterManualScroll);
      });
    }

    _scrollingNotifierListener = onScrollingChanged;
    pos.isScrollingNotifier.addListener(_scrollingNotifierListener!);
  }

  void _startMarquee() {
    _marqueeTimer?.cancel();
    _marqueeTimer = Timer.periodic(_autoScrollInterval, (_) {
      if (_disposed || !mounted) return;
      if (!_scrollController.hasClients) return;
      final pos = _scrollController.position;
      if (!pos.hasContentDimensions || pos.maxScrollExtent <= 0) return;
      if (_manualScrollPauseUntil != null &&
          DateTime.now().isBefore(_manualScrollPauseUntil!)) {
        return;
      }
      final next = pos.pixels + _autoScrollPixelsPerTick;
      if (next >= pos.maxScrollExtent) {
        _scrollController.jumpTo(0);
      } else {
        _scrollController.jumpTo(next.clamp(0.0, pos.maxScrollExtent));
      }
    });
  }

  @override
  void dispose() {
    _disposed = true;
    final timer = _marqueeTimer;
    _marqueeTimer = null;
    timer?.cancel();
    if (_scrollController.hasClients && _scrollingNotifierListener != null) {
      try {
        _scrollController.position.isScrollingNotifier.removeListener(
          _scrollingNotifierListener!,
        );
      } catch (_) {}
    }
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 4.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoTranslateText(
              widget.title,
              style: MyTextTheme.mediumBCB
                  .copyWith(
                    color: "#F7C443".toColor(),
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Baloo Bhai 2',
                    fontSize: 15.sp,
                  )
                  .merge(AppTypography.h3),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: true,
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              widget.sanskritText,
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#F7C443".toColor(),
                fontWeight: FontWeight.w900,
                fontFamily: 'Poppins',
                fontSize: 15.sp,
                height: 1.5,
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
            SizedBox(height: 8.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: AutoTranslateText(
                widget.meaning,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: "#F7C443".toColor(),
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                  fontSize: 14.sp,
                  height: 1.6,
                ),
                textAlign: TextAlign.center,
                softWrap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
