import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';

/// Remedy & Suggestion Layer
/// Shows remedies when user taps on red zone or direction
class RemedySuggestionLayer extends StatefulWidget {
  final VastuRoomConfig roomConfig;
  final String currentDirection;
  final VoidCallback onClose;

  const RemedySuggestionLayer({
    Key? key,
    required this.roomConfig,
    required this.currentDirection,
    required this.onClose,
  }) : super(key: key);

  @override
  State<RemedySuggestionLayer> createState() => _RemedySuggestionLayerState();
}

class _RemedySuggestionLayerState extends State<RemedySuggestionLayer>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOut,
      ),
    );
    
    _slideController.forward();
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  bool get isAvoidDirection => widget.roomConfig.isAvoidDirection(widget.currentDirection);
  bool get isIdealDirection => widget.roomConfig.isIdealDirection(widget.currentDirection);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _slideController.reverse().then((_) => widget.onClose());
      },
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: SlideTransition(
          position: _slideAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin: EdgeInsets.all(20.w),
                padding: EdgeInsets.all(24.w),
                decoration: BoxDecoration(
                  color: '#FFF8E1'.toColor(),
                  borderRadius: BorderRadius.circular(24.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              AutoTranslateText(
                                '${widget.roomConfig.displayName} - ${widget.currentDirection}',
                                style: MyTextTheme.largeBCB.copyWith(
                                  color: '#3E2723'.toColor(),
                                  fontWeight: FontWeight.bold,
                                ).merge(AppTypography.h2),
                              ),
                              Spacing.h(4),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                                decoration: BoxDecoration(
                                  color: isAvoidDirection
                                      ? '#C62828'.toColor().withOpacity(0.1)
                                      : isIdealDirection
                                          ? '#2E7D32'.toColor().withOpacity(0.1)
                                          : '#E6CBA8'.toColor().withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                    color: isAvoidDirection
                                        ? '#C62828'.toColor()
                                        : isIdealDirection
                                            ? '#2E7D32'.toColor()
                                            : '#E6CBA8'.toColor(),
                                    width: 1.5,
                                  ),
                                ),
                                child: AutoTranslateText(
                                  isAvoidDirection
                                      ? 'Avoid Direction'
                                      : isIdealDirection
                                          ? 'Ideal Direction'
                                          : 'Neutral Direction',
                                  style: MyTextTheme.smallBCB.copyWith(
                                    color: isAvoidDirection
                                        ? '#C62828'.toColor()
                                        : isIdealDirection
                                            ? '#2E7D32'.toColor()
                                            : '#D4AF37'.toColor(),
                                    fontWeight: FontWeight.bold,
                                  ).merge(AppTypography.body2),
                                ),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            _slideController.reverse().then((_) => widget.onClose());
                          },
                          child: Container(
                            padding: EdgeInsets.all(8.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.close,
                              color: '#3E2723'.toColor(),
                              size: 20.w,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Spacing.h(20),
                    
                    // Guidance
                    AutoTranslateText(
                      widget.roomConfig.getGuidanceForDirection(widget.currentDirection),
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#3E2723'.toColor(),
                      ).merge(AppTypography.body1),
                    ),
                    Spacing.h(20),
                    
                    // Remedies (if avoid direction)
                    if (isAvoidDirection) ...[
                      AutoTranslateText(
                        'Remedies & Corrections',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ).merge(AppTypography.h3),
                      ),
                      Spacing.h(12),
                      ...widget.roomConfig.remedies.map((remedy) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 4.h, right: 12.w),
                              width: 6.w,
                              height: 6.w,
                              decoration: BoxDecoration(
                                color: '#D4AF37'.toColor(),
                                shape: BoxShape.circle,
                              ),
                            ),
                            Expanded(
                              child: AutoTranslateText(
                                remedy,
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: '#666666'.toColor(),
                                ).merge(AppTypography.body2),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                    
                    // Suggestions (if ideal or neutral)
                    if (!isAvoidDirection) ...[
                      AutoTranslateText(
                        'Enhancement Suggestions',
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: '#3E2723'.toColor(),
                          fontWeight: FontWeight.bold,
                        ).merge(AppTypography.h3),
                      ),
                      Spacing.h(12),
                      ...widget.roomConfig.remedies.take(3).map((suggestion) => Padding(
                        padding: EdgeInsets.only(bottom: 8.h),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.check_circle_outline,
                              size: 18.w,
                              color: '#2E7D32'.toColor(),
                            ),
                            Spacing.w(12),
                            Expanded(
                              child: AutoTranslateText(
                                suggestion,
                                style: MyTextTheme.smallBCN.copyWith(
                                  color: '#666666'.toColor(),
                                ).merge(AppTypography.body2),
                              ),
                            ),
                          ],
                        ),
                      )),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}









