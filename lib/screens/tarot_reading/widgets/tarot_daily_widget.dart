import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/tarot_reading/controller/tarot_controller.dart';
import 'package:astrobharataiuser/screens/tarot_reading/widgets/tarot_card_display_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Daily Guidance Widget with Collapsible Panels
class TarotDailyWidget extends StatefulWidget {
  const TarotDailyWidget({super.key});

  @override
  State<TarotDailyWidget> createState() => _TarotDailyWidgetState();
}

class _TarotDailyWidgetState extends State<TarotDailyWidget> {
  final Map<String, bool> _expandedSections = {
    'health': false,
    'relationship': false,
    'career': false,
    'finance': false,
  };

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TarotController>();

    return Obx(() {
      if (controller.selectedReadingType.value != 'daily') {
        return const SizedBox.shrink();
      }
      
      final response = controller.dailyResponse.value;
      if (response == null) {
        // Show loading state
        return Container(
          color: Colors.black.withOpacity(0.7),
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      }

      return GestureDetector(
        onTap: () => controller.closeReading(),
        child: Container(
          color: Colors.black.withOpacity(0.7),
          child: Center(
            child: GestureDetector(
              onTap: () {},
              child: TweenAnimationBuilder<double>(
                tween: Tween(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 600),
                curve: Curves.elasticOut,
                builder: (context, value, child) {
                  final clampedValue = value.clamp(0.0, 1.0);
                  return Transform.scale(
                    scale: clampedValue,
                    child: Opacity(
                      opacity: clampedValue,
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 16.w),
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
                        decoration: BoxDecoration(
                          color: '#ede7c8'.toColor(),
                          borderRadius: BorderRadius.circular(20.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.all(24.w),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    AutoTranslateText(
                                      'Daily Guidance',
                                      style: MyTextTheme.largeBCB.copyWith(
                                        color: '#820B17'.toColor(),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () => controller.closeReading(),
                                      icon: Icon(
                                        Icons.close,
                                        color: '#820B17'.toColor(),
                                        size: 24.w,
                                      ),
                                    ),
                                  ],
                                ),
                                Spacing.h(16),
                                
                                // Card front image (theme selectable)
                                Center(
                                  child: TarotCardDisplayWidget(
                                    cardImage: response.cardImage,
                                    width: 120.w,
                                    height: 180.h,
                                  ),
                                ),
                                
                                Spacing.h(16),
                                
                                Spacing.h(16),
                                
                                // Card name
                                AutoTranslateText(
                                  response.name ?? controller.selectedCard?.name ?? 'Unknown Card',
                                  style: MyTextTheme.mediumBCN.copyWith(
                                    color: '#ee7532'.toColor(),
                                  ),
                                ),
                                
                                Spacing.h(24),
                                _buildCollapsibleSection(
                                  'health',
                                  Icons.favorite,
                                  'Health',
                                  response.health,
                                  Colors.red,
                                ),
                                Spacing.h(12),
                                _buildCollapsibleSection(
                                  'relationship',
                                  Icons.favorite_border,
                                  'Relationship',
                                  response.relationship,
                                  Colors.pink,
                                ),
                                Spacing.h(12),
                                _buildCollapsibleSection(
                                  'career',
                                  Icons.work,
                                  'Career',
                                  response.career,
                                  Colors.blue,
                                ),
                                Spacing.h(12),
                                _buildCollapsibleSection(
                                  'finance',
                                  Icons.attach_money,
                                  'Finance',
                                  response.finance,
                                  Colors.green,
                                ),
                                Spacing.h(24),
                                ElevatedButton(
                                  onPressed: () => controller.closeReading(),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: '#ee7532'.toColor(),
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 32.w,
                                      vertical: 12.h,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.r),
                                    ),
                                  ),
                                  child: AutoTranslateText(
                                    'Close',
                                    style: MyTextTheme.smallBCN.copyWith(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCollapsibleSection(
    String key,
    IconData icon,
    String title,
    String content,
    Color color,
  ) {
    final isExpanded = _expandedSections[key] ?? false;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: color.withOpacity(0.3),
        ),
      ),
      child: ExpansionTile(
        key: ValueKey(key),
        initiallyExpanded: isExpanded,
        onExpansionChanged: (expanded) {
          setState(() {
            _expandedSections[key] = expanded;
          });
        },
        leading: Icon(icon, color: color, size: 24.w),
        title: AutoTranslateText(
          title,
          style: MyTextTheme.mediumBCN.copyWith(
            color: '#820B17'.toColor(),
          ),
        ),
        children: [
          Padding(
            padding: EdgeInsets.all(16.w),
            child: AutoTranslateText(
              content.isNotEmpty ? content : 'No guidance available for this area.',
              style: MyTextTheme.smallBCN.copyWith(
                color: '#820B17'.toColor(),
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

