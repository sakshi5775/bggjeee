import 'package:astrobharataiuser/screens/ai_chat/controllers/ai_chat_controller.dart';
import 'package:astrobharataiuser/screens/ai_chat/views/ai_chat_view.dart';
import 'package:astrobharataiuser/screens/astrology_services/view/all_astrologers_view.dart';
import 'package:astrobharataiuser/screens/consult/controller/consult_controller.dart';
import 'package:astrobharataiuser/screens/user_dashboard/widgets/banner_carousel_widget.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ConsultView extends StatelessWidget {
  const ConsultView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ConsultController());

    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // endDrawer: const CommonEndDrawer(),
        body: SafeArea(
          top: true,
          bottom: false,
          child: Column(
            children: [
              CommonHeader(
                title: 'Consult',
                showBackButton: true,
                showWallet: true,
                showCart: true,
              ),
              _buildTabBar(controller),
              _buildSortFilterPills(context, controller),
              _buildSearchBar(controller),
              Expanded(
                child: Obx(() {
                  if (controller.tabIndex.value == 0) {
                    return const AllAstrologersView(
                      hideHeader: true,
                      showFilterChips: false,
                    );
                  }
                  if (!Get.isRegistered<AiChatController>()) {
                    Get.put(AiChatController(), permanent: false);
                  }
                  return AiChatView(
                    hideHeader: true,
                    bannerWidget: _buildAiBanner(controller),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTabBar(ConsultController controller) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.saffron.withOpacity(0.25)),
      ),
      child: Row(
        children: [
          _tabChip(controller, label: 'Astrologer', index: 0),
          _tabChip(controller, label: 'AI Astrologer', index: 1),
        ],
      ),
    );
  }

  Widget _tabChip(ConsultController controller, {required String label, required int index}) {
    return Obx(() {
      final selected = controller.tabIndex.value == index;
      return Expanded(
        child: GestureDetector(
          onTap: () => controller.setTab(index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: EdgeInsets.symmetric(vertical: 10.h),
            decoration: BoxDecoration(
              gradient: selected ? AppColors.orangeGradient : null,
              color: selected ? null : Colors.transparent,
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Center(
              child: AutoTranslateText(
                label,
                style: AppTypography.body1.copyWith(
                  color: selected ? Colors.white : const Color(0xFF5F2221),
                  fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildSearchBar(ConsultController controller) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 8.h),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.6),
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: const Color(0xFF5F2221).withOpacity(0.2)),
        ),
        child: TextField(
          onChanged: (v) => controller.globalSearchQuery.value = v,
          decoration: InputDecoration(
            hintText: 'Search astrologers, AI astrologers...',
            hintStyle: AppTypography.body2.copyWith(color: Colors.grey.shade600),
            prefixIcon: Icon(Icons.search, size: 22.w, color: const Color(0xFF5F2221)),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          ),
          style: AppTypography.body2.copyWith(color: const Color(0xFF5F2221)),
        ),
      ),
    );
  }

  Widget _buildSortFilterPills(BuildContext context, ConsultController controller) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Obx(
            () => _buildSmallPill(
              icon: Icons.swap_vert,
              label: controller.currentSortLabel,
              onTap: () => _showSortMenu(context, controller),
            ),
          ),
          SizedBox(width: 10.w),
          _buildSmallPill(
            icon: Icons.tune,
            label: 'Filters',
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => _ConsultFilterPage(
                    isAstrologerTab: controller.tabIndex.value == 0,
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSmallPill({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.5),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: const Color(0xFF5F2221).withOpacity(0.2),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18.w, color: const Color(0xFF5F2221)),
              SizedBox(width: 6.w),
              AutoTranslateText(
                label,
                style: AppTypography.body2.copyWith(
                  color: const Color(0xFF5F2221),
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(width: 2.w),
              Icon(Icons.arrow_drop_down, size: 20.w, color: const Color(0xFF5F2221)),
            ],
          ),
        ),
      ),
    );
  }

  void _showSortMenu(BuildContext context, ConsultController controller) {
    final options = controller.tabIndex.value == 0
        ? ConsultController.sortByOptions
        : ConsultController.aiSortByOptions;
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16.r))),
      builder: (ctx) => Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AutoTranslateText('Sort by', style: AppTypography.h3.copyWith(color: const Color(0xFF5F2221))),
            SizedBox(height: 12.h),
            ...options.map((o) {
              final isSelected = (controller.tabIndex.value == 0 ? controller.sortBy.value : controller.aiSortBy.value) == o.value;
              return ListTile(
                title: AutoTranslateText(o.label, style: AppTypography.body1),
                trailing: isSelected ? Icon(Icons.check, color: AppColors.saffron, size: 22.w) : null,
                onTap: () {
                  if (controller.tabIndex.value == 0) {
                    controller.sortBy.value = o.value;
                    controller.refreshAstrologerList();
                  } else {
                    controller.aiSortBy.value = o.value;
                    controller.loadPersonaSlider();
                  }
                  Navigator.pop(ctx);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAiBanner(ConsultController controller) {
    return Obx(() {
      var banners = controller.generalBanners;
      if (banners.isEmpty && Get.isRegistered<AiChatController>()) {
        banners = Get.find<AiChatController>().banners;
      }
      if (banners.isEmpty) return SizedBox(height: 4.h);
      return Padding(
        padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
        child: BannerCarouselWidget(banners: banners),
      );
    });
  }

}

class _ConsultFilterPage extends StatefulWidget {
  final bool isAstrologerTab;

  const _ConsultFilterPage({required this.isAstrologerTab});

  @override
  State<_ConsultFilterPage> createState() => _ConsultFilterPageState();
}

class _ConsultFilterPageState extends State<_ConsultFilterPage> {
  late ConsultController controller;
  String selectedCategory = 'Specialization';
  final TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  Timer? _filterDebounce;

  @override
  void initState() {
    super.initState();
    controller = Get.find<ConsultController>();
    if (!widget.isAstrologerTab) selectedCategory = 'Category';
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    setState(() {
      searchQuery = searchController.text.trim().toLowerCase();
    });
  }

  void _onFilterChanged() {
    _filterDebounce?.cancel();
    _filterDebounce = Timer(const Duration(milliseconds: 500), () {
      if (widget.isAstrologerTab) {
        controller.refreshAstrologerList();
      } else {
        controller.loadPersonaSlider();
      }
    });
  }

  @override
  void dispose() {
    _filterDebounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  List<String> get leftCategories {
    if (widget.isAstrologerTab) {
      return [
        'Specialization',
        'Language',
        'Availability',
        'Category',
        'Price',
        'Experience',
      ];
    }
    return ['Category', 'Featured'];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        top: true,
        bottom: false,
        child: Column(
          children: [
            CommonHeader(
              title: 'Filters',
              showBackButton: true,
              onBackTap: () => Navigator.of(context).pop(),
              showWallet: false,
              showCart: false,
              showSearch: false,
              showLanguage: false,
              showHome: false,
              customActions: [
                GestureDetector(
                  onTap: () {
                    searchController.clear();
                    searchQuery = '';
                    if (widget.isAstrologerTab) {
                      controller.clearAstrologerFilters();
                    } else {
                      controller.clearAiFilters();
                    }
                    setState(() {});
                  },
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
                    child: AutoTranslateText(
                      'Clear Filters',
                      style: AppTypography.body2.copyWith(
                        color: const Color(0xFF5F2221).withOpacity(0.7),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            _buildSearchBar(),
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildLeftColumn(),
                  Expanded(child: _buildRightColumn()),
                ],
              ),
            ),
            Obx(() => _buildBottomBar(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    String hint = widget.isAstrologerTab ? 'Search Specialization' : 'Search Category';
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 12.h),
      child: Container(
        height: 44.h,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(color: Colors.grey.shade300),
        ),
        child: TextField(
          controller: searchController,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(color: Colors.grey.shade600, fontSize: 14.sp),
            prefixIcon: Icon(Icons.search, size: 22.w, color: Colors.grey.shade600),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
          ),
          style: AppTypography.body2.copyWith(color: const Color(0xFF5F2221)),
        ),
      ),
    );
  }

  Widget _buildLeftColumn() {
    return Container(
      width: 120.w,
      color: const Color(0xFFF5F5F5),
      child: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: leftCategories.length,
        itemBuilder: (context, index) {
          final name = leftCategories[index];
          final isSelected = selectedCategory == name;
          return GestureDetector(
            onTap: () => setState(() => selectedCategory = name),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 14.h),
              color: isSelected ? Colors.white : Colors.transparent,
              child: AutoTranslateText(
                name,
                style: AppTypography.body2.copyWith(
                  color: isSelected
                      ? AppColors.saffron
                      : const Color(0xFF5F2221),
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRightColumn() {
    final Widget optionsWidget = widget.isAstrologerTab
        ? _buildAstrologerOptions()
        : _buildAiOptions();
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AutoTranslateText(
            'Popular Filters',
            style: AppTypography.body2.copyWith(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 12.h),
          optionsWidget,
        ],
      ),
    );
  }

  Widget _buildAstrologerOptions() {
    if (selectedCategory == 'Specialization') {
      final list = ConsultController.specializationOptions
          .where((o) => searchQuery.isEmpty || o.label.toLowerCase().contains(searchQuery))
          .toList();
      return _buildCheckboxList(
        list.map((e) => e.value).toList(),
        list.map((e) => e.label).toList(),
        controller.selectedSpecializations,
        true,
      );
    }
    if (selectedCategory == 'Language') {
      final list = ConsultController.languageOptions
          .where((o) => searchQuery.isEmpty || o.label.toLowerCase().contains(searchQuery))
          .toList();
      return _buildCheckboxList(
        list.map((e) => e.value).toList(),
        list.map((e) => e.label).toList(),
        controller.selectedLanguages,
        true,
      );
    }
    if (selectedCategory == 'Availability') {
      return _buildRadioList(
        ConsultController.availabilityOptions.map((e) => e.value).toList(),
        ConsultController.availabilityOptions.map((e) => e.label).toList(),
        controller.availability,
      );
    }
    if (selectedCategory == 'Category') {
      return _buildRadioList(
        ConsultController.astrologerCategoryOptions.map((e) => e.value).toList(),
        ConsultController.astrologerCategoryOptions.map((e) => e.label).toList(),
        controller.astrologerCategory,
      );
    }
    if (selectedCategory == 'Price') {
      return _buildPriceOptions(ConsultController.priceFilterOptions);
    }
    if (selectedCategory == 'Experience') {
      return _buildExperienceOptions(ConsultController.experienceFilterOptions);
    }
    return const SizedBox.shrink();
  }

  Widget _buildAiOptions() {
    if (selectedCategory == 'Category') {
      final list = controller.aiCategories
          .where((c) => searchQuery.isEmpty || c.label.toLowerCase().contains(searchQuery))
          .toList();
      return _buildCheckboxList(
        list.map((e) => e.value).toList(),
        list.map((e) => e.label).toList(),
        controller.selectedAiCategoryValues,
        true,
      );
    }
    if (selectedCategory == 'Featured') {
      final isFeatured = controller.aiFeatured.value;
      return CheckboxListTile(
        value: isFeatured,
        onChanged: (bool? v) {
          controller.aiFeatured.value = v ?? false;
          setState(() {});
          _onFilterChanged();
        },
        title: AutoTranslateText('Featured only', style: AppTypography.body2),
        activeColor: AppColors.saffron,
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildCheckboxList(
    List<String> values,
    List<String> labels,
    RxList<String> selected,
    bool multi,
  ) {
    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < values.length; i++) {
      final v = values[i];
      final label = i < labels.length ? labels[i] : v;
      final isSelected = selected.contains(v);
      tiles.add(CheckboxListTile(
          value: isSelected,
          onChanged: (bool? checked) {
            if (multi) {
              if (checked == true) {
                selected.add(v);
              } else {
                selected.remove(v);
              }
            } else {
              selected.clear();
              if (checked == true) selected.add(v);
            }
            setState(() {});
            _onFilterChanged();
          },
          title: AutoTranslateText(label, style: AppTypography.body2),
          activeColor: AppColors.saffron,
          controlAffinity: ListTileControlAffinity.leading,
        ));
    }
    return Column(children: tiles);
  }

  Widget _buildRadioList(
    List<String> values,
    List<String> labels,
    RxString selected,
  ) {
    final List<Widget> tiles = <Widget>[];
    for (int i = 0; i < values.length; i++) {
      final v = values[i];
      final label = i < labels.length ? labels[i] : v;
      tiles.add(RadioListTile<String>(
        value: v,
        groupValue: selected.value,
        onChanged: (String? val) {
          selected.value = val ?? selected.value;
          setState(() {});
          _onFilterChanged();
        },
        title: AutoTranslateText(label, style: AppTypography.body2),
        activeColor: AppColors.saffron,
      ));
    }
    return Column(children: tiles);
  }

  Widget _buildPriceOptions(List<double> options) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < options.length; i++) {
      final price = options[i];
      final isBelowSelected = controller.maxPrice.value == price;
      children.add(CheckboxListTile(
        value: isBelowSelected,
        onChanged: (bool? v) {
          controller.maxPrice.value = v == true ? price : 0;
          setState(() {});
          _onFilterChanged();
        },
        title: AutoTranslateText('Below Rs ${price.toInt()}/min', style: AppTypography.body2),
        activeColor: AppColors.saffron,
        controlAffinity: ListTileControlAffinity.leading,
      ));
    }
    for (int i = 0; i < options.length; i++) {
      final price = options[i];
      final isAboveSelected = controller.minPrice.value == price;
      children.add(CheckboxListTile(
        value: isAboveSelected,
        onChanged: (bool? v) {
          controller.minPrice.value = v == true ? price : 0;
          setState(() {});
          _onFilterChanged();
        },
        title: AutoTranslateText('Above Rs ${price.toInt()}/min', style: AppTypography.body2),
        activeColor: AppColors.saffron,
        controlAffinity: ListTileControlAffinity.leading,
      ));
    }
    return Column(children: children);
  }

  Widget _buildExperienceOptions(List<int> options) {
    final List<Widget> children = <Widget>[];
    for (int i = 0; i < options.length; i++) {
      final exp = options[i];
      final isSelected = controller.minExperience.value == exp;
      children.add(CheckboxListTile(
        value: isSelected,
        onChanged: (bool? v) {
          controller.minExperience.value = v == true ? exp : 0;
          setState(() {});
          _onFilterChanged();
        },
        title: AutoTranslateText('${exp}+ years', style: AppTypography.body2),
        activeColor: AppColors.saffron,
        controlAffinity: ListTileControlAffinity.leading,
      ));
    }
    return Column(children: children);
  }

  Widget _buildBottomBar(BuildContext context) {
    final count = widget.isAstrologerTab
        ? controller.astrologersTotalCount.value
        : (Get.isRegistered<AiChatController>()
            ? Get.find<AiChatController>().filteredPersonas.length
            : controller.personasTotalCount.value);
    final label = widget.isAstrologerTab ? 'astrologers' : 'AI astrologers';
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: AutoTranslateText(
              '$count $label found',
              style: AppTypography.body2.copyWith(
                color: Colors.grey.shade700,
              ),
            ),
          ),
          Material(
            borderRadius: BorderRadius.circular(8.r),
            child: Container(
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(8.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.saffron.withOpacity(0.3),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: InkWell(
                onTap: () {
                  if (widget.isAstrologerTab) {
                    controller.applyAstrologerFiltersAndReload();
                  } else {
                    controller.applyPersonaFiltersAndReload();
                  }
                  Navigator.of(context).pop();
                },
                borderRadius: BorderRadius.circular(8.r),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 12.h),
                  child: AutoTranslateText(
                    'Apply',
                    style: AppTypography.body1.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
