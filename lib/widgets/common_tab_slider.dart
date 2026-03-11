import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// Standard Common Tab Slider for the application.
/// [tabPricingKeys] optional: same order as [tabs]; non-empty key shows price badge on that tab.
class CommonTabSlider extends StatefulWidget {
  final List<String> tabs;
  final int selectedIndex;
  final Function(int) onTabSelected;
  final ScrollController? scrollController;
  /// Optional: pricing key per tab (e.g. 'navtara' for Navtara tab). Same length as [tabs].
  final List<String?>? tabPricingKeys;

  const CommonTabSlider({
    super.key,
    required this.tabs,
    required this.selectedIndex,
    required this.onTabSelected,
    this.scrollController,
    this.tabPricingKeys,
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
              final pricingKey = widget.tabPricingKeys != null &&
                      index < widget.tabPricingKeys!.length &&
                      widget.tabPricingKeys![index] != null &&
                      widget.tabPricingKeys![index]!.isNotEmpty
                  ? widget.tabPricingKeys![index]!
                  : null;

              if (!_tabKeys.containsKey(index)) {
                _tabKeys[index] = GlobalKey();
              }

              Widget tabChip = AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(
                  horizontal: 16.w,
                  vertical: Get.width > 600 ? 12.h : 8.h,
                ),
                decoration: BoxDecoration(
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
              );

              if (pricingKey != null &&
                  Get.isRegistered<AiPricingController>()) {
                tabChip = Stack(
                  clipBehavior: Clip.none,
                  children: [
                    tabChip,
                    Positioned(
                      top: -4.h,
                      right: -4.w,
                      child: _PriceBadge(pricingKey: pricingKey),
                    ),
                  ],
                );
              }

              return Padding(
                key: _tabKeys[index],
                padding: EdgeInsets.only(right: 6.w),
                child: GestureDetector(
                  onTap: () => widget.onTabSelected(index),
                  child: tabChip,
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

class _PriceBadge extends StatelessWidget {
  final String pricingKey;

  const _PriceBadge({required this.pricingKey});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ctrl = Get.find<AiPricingController>();
      final pricing = ctrl.getPricingFor(pricingKey);
      if (pricing == null) return const SizedBox.shrink();
      final price = ctrl.getDisplayPrice(pricingKey);
      final badgeText = price.isNotEmpty ? price : 'Paid';
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 2.h),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF6B35), Color(0xFFF38B3B)],
          ),
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.15),
              blurRadius: 3,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Text(
          badgeText,
          style: TextStyle(
            color: Colors.white,
            fontSize: 8.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Poppins',
          ),
        ),
      );
    });
  }
}
