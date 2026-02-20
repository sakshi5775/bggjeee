import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class EmptyStateWidget extends StatelessWidget {
  final bool isEmpty;
  final bool hasFilter;
  final VoidCallback onClearFilter;

  const EmptyStateWidget({
    super.key,
    required this.isEmpty,
    required this.hasFilter,
    required this.onClearFilter,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppPaddings.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: AppPaddings.all(24),
              decoration: BoxDecoration(
                color: AppColors.saffron.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEmpty ? Icons.auto_awesome_outlined : Icons.search_off,
                size: 64.h,
                color: AppColors.saffron,
              ),
            ),
            Spacing.h(24),
            LocalizedText(
              text: isEmpty
                  ? 'No AI Personas Available'
                  : 'No Results Found',
              style: MyTextTheme.largeBCB.copyWith(
                color: AppColors.textPrimary,
              ).merge(AppTypography.h2),
            ),
            Spacing.h(8),
            LocalizedText(
              text: isEmpty
                  ? 'AI chat personas will appear here when available'
                  : 'Try adjusting your filters or search query',
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (hasFilter) ...[
              Spacing.h(24),
              ElevatedButton.icon(
                onPressed: onClearFilter,
                icon: const Icon(Icons.clear_all, color: AppColors.textLight),
                label: LocalizedText(
                  text: 'Clear Filters',
                  style: MyTextTheme.smallBCB.copyWith(
                    color: AppColors.textLight,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.saffron,
                  padding: AppPaddings.symmetric(h: 20, v: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppRadius.all(12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


