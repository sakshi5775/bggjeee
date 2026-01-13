import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/vastu/model/vastu_room_config.dart';

/// Expandable "Why This Matters" card
/// Educates user and increases retention
class WhyThisMattersCard extends StatefulWidget {
  final VastuRoomConfig roomConfig;
  final String currentDirection;

  const WhyThisMattersCard({
    Key? key,
    required this.roomConfig,
    required this.currentDirection,
  }) : super(key: key);

  @override
  State<WhyThisMattersCard> createState() => _WhyThisMattersCardState();
}

class _WhyThisMattersCardState extends State<WhyThisMattersCard>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _rotationAnimation;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    
    _rotationAnimation = Tween<double>(
      begin: 0.0,
      end: 0.5,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
    
    _heightAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpanded() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isIdeal = widget.roomConfig.isIdealDirection(widget.currentDirection);
    final isAvoid = widget.roomConfig.isAvoidDirection(widget.currentDirection);
    
    String explanation;
    if (isIdeal) {
      explanation = 'This direction is ideal for ${widget.roomConfig.displayName} because it aligns with the natural energy flow. Following Vastu principles in this direction brings harmony, prosperity, and positive energy to your space.';
    } else if (isAvoid) {
      explanation = 'This direction should be avoided for ${widget.roomConfig.displayName} as it conflicts with Vastu principles. Placing this room here may cause negative energy, health issues, or financial problems. Consider remedies or relocation.';
    } else {
      explanation = 'This direction is neutral for ${widget.roomConfig.displayName}. While not ideal, it can work with proper Vastu remedies and adjustments. Consider implementing suggested remedies for better results.';
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#F5D7B8'.toColor(),
          width: 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          GestureDetector(
            onTap: _toggleExpanded,
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Row(
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: '#FF6B35'.toColor(),
                    size: 20.w,
                  ),
                  Spacing.w(12),
                  Expanded(
                    child: AutoTranslateText(
                      'Why This Matters',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h3),
                    ),
                  ),
                  RotationTransition(
                    turns: _rotationAnimation,
                    child: Icon(
                      Icons.expand_more,
                      color: '#3E2723'.toColor(),
                      size: 24.w,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizeTransition(
            sizeFactor: _heightAnimation,
            child: Padding(
              padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 16.w),
              child: AutoTranslateText(
                explanation,
                style: MyTextTheme.smallBCN.copyWith(
                  color: '#666666'.toColor(),
                  height: 1.5,
                ).merge(AppTypography.body1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

