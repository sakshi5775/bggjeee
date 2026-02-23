import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';

/// Vastu History Timeline Widget
/// Shows saved direction scans with date, room, and direction
class VastuHistoryTimeline extends StatelessWidget {
  final List<Map<String, dynamic>> history;
  final Function(Map<String, dynamic>)? onItemTap;
  final VoidCallback? onClear;

  const VastuHistoryTimeline({
    Key? key,
    required this.history,
    this.onItemTap,
    this.onClear,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64.w,
              color: Colors.grey.withValues(alpha: 0.5),
            ),
            Spacing.h(16),
            AutoTranslateText(
              'No History Yet',
              style: MyTextTheme.mediumBCN
                  .copyWith(color: Colors.grey)
                  .merge(AppTypography.body1),
            ),
            Spacing.h(8),
            AutoTranslateText(
              'Save direction scans to view history',
              style: MyTextTheme.smallBCN
                  .copyWith(color: Colors.grey.withValues(alpha: 0.7))
                  .merge(AppTypography.body2),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AutoTranslateText(
                'Vastu History',
                style: MyTextTheme.largeBCB
                    .copyWith(
                      color: '#3E2723'.toColor(),
                      fontWeight: FontWeight.bold,
                    )
                    .merge(AppTypography.h2),
              ),
              if (onClear != null)
                TextButton.icon(
                  onPressed: onClear,
                  icon: Icon(
                    Icons.delete_outline,
                    size: 18.w,
                    color: '#C62828'.toColor(),
                  ),
                  label: AutoTranslateText(
                    'Clear',
                    style: MyTextTheme.smallBCB
                        .copyWith(color: '#C62828'.toColor())
                        .merge(AppTypography.body2),
                  ),
                ),
            ],
          ),
        ),
        // Timeline
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            itemCount: history.length,
            itemBuilder: (context, index) {
              final entry = history[index];
              return _buildHistoryItem(entry, index == history.length - 1);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryItem(Map<String, dynamic> entry, bool isLast) {
    final timestamp = DateTime.tryParse(entry['timestamp'] ?? '');
    final dateStr = timestamp != null
        ? DateFormat('MMM dd, yyyy • hh:mm a').format(timestamp)
        : 'Unknown date';
    final direction = entry['direction'] ?? 'N';
    final heading = entry['heading'] ?? '0.0';
    final roomName = entry['roomName'] ?? 'Unknown Room';
    final accuracy = entry['accuracy'] ?? '0';
    return GestureDetector(
      onTap: () => onItemTap?.call(entry),
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: '#F5D7B8'.toColor(), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Timeline indicator
            Column(
              children: [
                Container(
                  width: 12.w,
                  height: 12.w,
                  decoration: BoxDecoration(
                    color: '#D4AF37'.toColor(),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                ),
                if (!isLast)
                  Container(width: 2, height: 60.h, color: '#E6CBA8'.toColor()),
              ],
            ),
            Spacing.w(16),

            // Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: AutoTranslateText(
                          roomName,
                          style: MyTextTheme.mediumBCB
                              .copyWith(
                                color: '#3E2723'.toColor(),
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.body1),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: '#D4AF37'.toColor().withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: AutoTranslateText(
                          direction,
                          style: MyTextTheme.smallBCB
                              .copyWith(
                                color: '#D4AF37'.toColor(),
                                fontWeight: FontWeight.bold,
                              )
                              .merge(AppTypography.body2),
                        ),
                      ),
                    ],
                  ),
                  Spacing.h(8),
                  Row(
                    children: [
                      Icon(
                        Icons.navigation,
                        size: 14.w,
                        color: '#666666'.toColor(),
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        '$heading°',
                        style: MyTextTheme.smallBCN
                            .copyWith(color: '#666666'.toColor())
                            .merge(AppTypography.body2),
                      ),
                      Spacing.w(16),
                      Icon(
                        Icons.check_circle_outline,
                        size: 14.w,
                        color: '#666666'.toColor(),
                      ),
                      Spacing.w(4),
                      AutoTranslateText(
                        '$accuracy% Accuracy',
                        style: MyTextTheme.smallBCN
                            .copyWith(color: '#666666'.toColor())
                            .merge(AppTypography.body2),
                      ),
                    ],
                  ),
                  Spacing.h(4),
                  AutoTranslateText(
                    dateStr,
                    style: MyTextTheme.smallBCN
                        .copyWith(color: Colors.grey)
                        .merge(AppTypography.body2),
                  ),
                ],
              ),
            ),

            // Arrow
            Icon(Icons.chevron_right, color: '#D4AF37'.toColor(), size: 24.w),
          ],
        ),
      ),
    );
  }
}
