import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Standard Common Tab Slider for the application.
/// Based on the slider implementation in KundliResultView.
class CommonTabSlider extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final ScrollController? scrollController;

  const CommonTabSlider({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.scrollController,
  });

  @override
  State<CommonTabSlider> createState() => _CommonTabSliderState();
}

class _CommonTabSliderState extends State<CommonTabSlider> {
  late ScrollController _scrollController;
  final Map<int, GlobalKey> _tabKeys = {};

  // Constants consistent with Kundli styling
  static const orange = Color(0xFFed6f30);
  static const maroon = Color(0xFF6F221E);

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();

    // Initial scroll to selected index after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToSelectedTab(widget.selectedIndex);
    });
  }

  @override
  void didUpdateWidget(CommonTabSlider oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedIndex != oldWidget.selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToSelectedTab(widget.selectedIndex);
      });
    }
  }

  @override
  void dispose() {
    // Only dispose if we created it locally
    if (widget.scrollController == null) {
      _scrollController.dispose();
    }
    super.dispose();
  }

  void _scrollToSelectedTab(int index) {
    if (!_scrollController.hasClients) return;

    // Ensure layout is complete before trying to scroll to a specific context
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final key = _tabKeys[index];
      if (key?.currentContext != null) {
        final renderObject = key!.currentContext!.findRenderObject();
        if (renderObject is RenderBox && renderObject.hasSize) {
          Scrollable.ensureVisible(
            key.currentContext!,
            alignment: 0.5, // Center the tab
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 16.w),
            ...widget.tabs.asMap().entries.map((entry) {
              final index = entry.key;
              final tabLabel = entry.value;
              final isSelected = widget.selectedIndex == index;

              if (!_tabKeys.containsKey(index)) {
                _tabKeys[index] = GlobalKey();
              }

              return Padding(
                key: _tabKeys[index],
                padding: EdgeInsets.only(right: 6.w),
                child: GestureDetector(
                  onTap: () => widget.onTabSelected(index),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOut,
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: Get.width > 600 ? 12.h : 8.h,
                    ),
                    decoration: BoxDecoration(
                      // color: isSelected ? orange : Colors.transparent,
                      gradient: isSelected ? AppColors.orangeGradient : null,
                      borderRadius: BorderRadius.circular(12.r),
                      border: isSelected
                          ? null
                          : Border.all(
                              color: maroon.withValues(alpha: 0.2),
                              width: 1,
                            ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: orange.withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ]
                          : null,
                    ),
                    child: Center(
                      child: AutoTranslateText(
                        tabLabel,
                        textAlign: TextAlign.center,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: isSelected ? Colors.white : AppColors.saffron,
                          fontWeight: isSelected
                              ? FontWeight.w700
                              : FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }),
            SizedBox(width: 10.w),
          ],
        ),
      ),
    );
  }
}
