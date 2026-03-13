import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/match_making/match_making/controller/match_making_form_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/address_autocomplete_field.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class MatchMakingFormView extends BasePage<MatchMakingFormController> {
  const MatchMakingFormView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        endDrawer: const CommonEndDrawer(),
        body: Column(
          children: [
            const CommonHeader(title: 'Match Making'),
            // Tab Bar
            _buildTabBar(),
            // Tab Content
            Expanded(
              child: Obx(() {
                if (controller.selectedTabIndex.value == 0) {
                  return _buildSavedMatchmakingTab();
                } else {
                  return SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 20.h,
                    ),
                    child: _buildFormContent(),
                  );
                }
              }),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Tab Bar =====
  Widget _buildTabBar() {
    return Obx(
      () => Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: AppColors.deepOrange.withValues(alpha: 0.3),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.08),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildTabItem('Saved Match', 0),
            _buildTabItem('New Match', 1),
          ],
        ),
      ),
    );
  }

  Widget _buildTabItem(String title, int index) {
    final isSelected = controller.selectedTabIndex.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.selectedTabIndex.value = index,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            gradient: isSelected ? AppColors.orangeGradient : null,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Center(
            child: AutoTranslateText(
              title,
              style: MyTextTheme.mediumBCB.copyWith(
                color: isSelected ? Colors.white : AppColors.textColorMaroon,
                fontSize: 14.sp,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ===== Saved Matchmaking Tab =====
  Widget _buildSavedMatchmakingTab() {
    return Column(
      children: [
        // Search Bar
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(
                color: AppColors.deepOrange.withValues(alpha: 0.2),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.deepOrange.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              onChanged: (v) => controller.searchQuery.value = v,
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.textColorMaroon,
              ),
              decoration: InputDecoration(
                isDense: true,
                contentPadding: EdgeInsets.symmetric(
                  vertical: 12.h,
                  horizontal: 14.w,
                ),
                hintText: 'Search by name',
                hintStyle: MyTextTheme.smallBCN.copyWith(
                  color: AppColors.textSecondary.withValues(alpha: 0.6),
                  fontSize: 13.sp,
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.deepOrange,
                  size: 22.w,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
        ),
        // List
        Expanded(
          child: Obx(() {
            if (controller.isLoadingSavedMatchmaking.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.deepOrange),
              );
            }
            final list = controller.filteredMatchmakingList;
            if (list.isEmpty) {
              return _buildEmptyState();
            }
            return Stack(
              children: [
                RefreshIndicator(
                  color: AppColors.deepOrange,
                  onRefresh: () => controller.fetchSavedMatchmakingProfiles(),
                  child: ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 4.h,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _buildSavedMatchmakingCard(list[index]);
                    },
                  ),
                ),
                // Loading overlay when opening a saved matchmaking
                Obx(() {
                  if (controller.isOpeningSavedMatchmaking.value) {
                    return Container(
                      color: Colors.black.withValues(alpha: 0.3),
                      child: Center(
                        child: Container(
                          padding: EdgeInsets.all(24.w),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16.r),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.deepOrange.withValues(
                                  alpha: 0.2,
                                ),
                                blurRadius: 20,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              CircularProgressIndicator(
                                color: AppColors.deepOrange,
                              ),
                              SizedBox(height: 16.h),
                              AutoTranslateText(
                                'Generating Match...',
                                style: MyTextTheme.mediumBCB.copyWith(
                                  color: AppColors.textColorMaroon,
                                  fontSize: 14.sp,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                }),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.favorite_border,
            color: AppColors.deepOrange.withValues(alpha: 0.4),
            size: 64.w,
          ),
          SizedBox(height: 16.h),
          AutoTranslateText(
            'No saved matches found',
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Create a new match to get started',
            style: MyTextTheme.smallBCN.copyWith(
              color: AppColors.textSecondary.withValues(alpha: 0.7),
              fontSize: 13.sp,
            ),
          ),
          SizedBox(height: 24.h),
          GestureDetector(
            onTap: () => controller.selectedTabIndex.value = 1,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: AutoTranslateText(
                'Create New Match',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavedMatchmakingCard(Map<String, dynamic> profile) {
    final boy = profile['boy'] as Map<String, dynamic>?;
    final girl = profile['girl'] as Map<String, dynamic>?;
    final boyName = boy?['name'] ?? 'Unknown';
    final girlName = girl?['name'] ?? 'Unknown';
    final boyPlace = boy?['birthPlace'] ?? '';
    final girlPlace = girl?['birthPlace'] ?? '';
    final boyDob = boy?['dateOfBirth'] ?? '';
    final girlDob = girl?['dateOfBirth'] ?? '';

    // Format dates
    String boyDisplayDate = boyDob;
    String girlDisplayDate = girlDob;
    try {
      if (boyDob.isNotEmpty) {
        final parts = boyDob.split('/');
        if (parts.length == 3) {
          boyDisplayDate = DateFormat('dd-MMM-yyyy').format(
            DateTime(
              int.parse(parts[2]),
              int.parse(parts[0]),
              int.parse(parts[1]),
            ),
          );
        }
      }
      if (girlDob.isNotEmpty) {
        final parts = girlDob.split('/');
        if (parts.length == 3) {
          girlDisplayDate = DateFormat('dd-MMM-yyyy').format(
            DateTime(
              int.parse(parts[2]),
              int.parse(parts[0]),
              int.parse(parts[1]),
            ),
          );
        }
      }
    } catch (e) {
      // Use raw format
    }

    return GestureDetector(
      onTap: () => controller.openSavedMatchmaking(profile),
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: AppColors.deepOrange.withValues(alpha: 0.15),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // Avatars Column
            Column(
              children: [
                // Boy avatar
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    gradient: AppColors.orangeGradient,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(Icons.male, color: Colors.white, size: 20.w),
                  ),
                ),
                SizedBox(height: 4.h),
                Icon(Icons.favorite, color: AppColors.deepOrange, size: 14.w),
                SizedBox(height: 4.h),
                // Girl avatar
                Container(
                  width: 38.w,
                  height: 38.w,
                  decoration: BoxDecoration(
                    color: AppColors.deepOrange.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      Icons.female,
                      color: AppColors.deepOrange,
                      size: 20.w,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 12.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Boy info
                  Text(
                    boyName,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textColorMaroon,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$boyDisplayDate • $boyPlace',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8.h),
                  // Divider
                  Container(
                    height: 1,
                    color: AppColors.deepOrange.withValues(alpha: 0.1),
                  ),
                  SizedBox(height: 8.h),
                  // Girl info
                  Text(
                    girlName,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textColorMaroon,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    '$girlDisplayDate • $girlPlace',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 11.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            // Three-dot menu
            PopupMenuButton<String>(
              icon: Icon(
                Icons.more_vert,
                color: AppColors.deepOrange,
                size: 22.w,
              ),
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              onSelected: (value) {
                switch (value) {
                  case 'view':
                    controller.openSavedMatchmaking(profile);
                    break;
                  case 'edit':
                    controller.editSavedMatchmaking(profile);
                    break;
                  case 'delete':
                    _showDeleteConfirmation(profile);
                    break;
                }
              },
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'view',
                  child: Row(
                    children: [
                      Icon(
                        Icons.visibility,
                        color: AppColors.deepOrange,
                        size: 20.w,
                      ),
                      SizedBox(width: 10.w),
                      AutoTranslateText(
                        'View Match',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: AppColors.textColorMaroon,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'edit',
                  child: Row(
                    children: [
                      Icon(Icons.edit, color: AppColors.deepOrange, size: 20.w),
                      SizedBox(width: 10.w),
                      AutoTranslateText(
                        'Edit Match',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: AppColors.textColorMaroon,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'delete',
                  child: Row(
                    children: [
                      Icon(Icons.delete, color: AppColors.error, size: 20.w),
                      SizedBox(width: 10.w),
                      AutoTranslateText(
                        'Delete Match',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: AppColors.error,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(Map<String, dynamic> profile) {
    final boyName = profile['boy']?['name'] ?? '';
    final girlName = profile['girl']?['name'] ?? '';
    final id = profile['_id']?.toString();
    if (id == null) return;

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: AutoTranslateText(
          'Delete Match',
          style: MyTextTheme.largeBCB.copyWith(
            color: AppColors.textColorMaroon,
            fontSize: 18.sp,
          ),
        ),
        content: AutoTranslateText(
          'Are you sure you want to delete the match between "$boyName" and "$girlName"? This action cannot be undone.',
          style: MyTextTheme.mediumBCN.copyWith(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: AutoTranslateText(
              'Cancel',
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.textSecondary,
                fontSize: 14.sp,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              controller.deleteSavedMatchmakingProfile(id);
            },
            child: AutoTranslateText(
              'Delete',
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.error,
                fontSize: 14.sp,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===== Form Content (New Match Tab) =====
  Widget _buildFormContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Enter Details',
          style: MyTextTheme.largeBCB
              .copyWith(color: '#68171E'.toColor(), fontWeight: FontWeight.bold)
              .merge(AppTypography.h2),
        ),
        Spacing.h(20),

        // Person 1 Section
        _buildPersonSection(
          label: 'Person 1',
          subLabel: 'Groom Details',
          nameController: controller.person1NameController,
          dateController: controller.person1DateController,
          timeController: controller.person1TimeController,
          placeController: controller.person1PlaceController,
          onDateTap: () => _showDatePicker(Get.context!, true),
          onTimeTap: () => _showTimePicker(Get.context!, true),
          onPlaceSelected: (place) =>
              controller.setPerson1LocationFromAutocomplete(place),
          isPerson1: true,
        ),

        Spacing.h(16),

        // Swap Icon
        Center(
          child: GestureDetector(
            onTap: () => controller.swapPersons(),
            child: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: '#F38B3B'.toColor().withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.swap_vert, color: Colors.white, size: 24.w),
            ),
          ),
        ),

        Spacing.h(16),

        // Person 2 Section
        _buildPersonSection(
          label: 'Person 2',
          subLabel: 'Bride',
          nameController: controller.person2NameController,
          dateController: controller.person2DateController,
          timeController: controller.person2TimeController,
          placeController: controller.person2PlaceController,
          onDateTap: () => _showDatePicker(Get.context!, false),
          onTimeTap: () => _showTimePicker(Get.context!, false),
          onPlaceSelected: (place) =>
              controller.setPerson2LocationFromAutocomplete(place),
          isPerson1: false,
        ),

        Spacing.h(20),

        // Language Dropdown
        _buildLanguageDropdown(),

        Spacing.h(20),

        // Save checkbox
        _buildSaveCheckbox(),

        Spacing.h(20),

        // Compare Kundlis Button
        _buildCompareButton(),

        Spacing.h(20),
      ],
    );
  }

  // ===== Save Checkbox =====
  Widget _buildSaveCheckbox() {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.saveMatchmakingChecked.toggle(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: controller.saveMatchmakingChecked.value
                ? AppColors.deepOrange.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: controller.saveMatchmakingChecked.value
                  ? AppColors.deepOrange.withValues(alpha: 0.4)
                  : AppColors.deepOrange.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 22.w,
                height: 22.w,
                decoration: BoxDecoration(
                  color: controller.saveMatchmakingChecked.value
                      ? AppColors.deepOrange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: controller.saveMatchmakingChecked.value
                        ? AppColors.deepOrange
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: controller.saveMatchmakingChecked.value
                    ? Icon(Icons.check, color: Colors.white, size: 16.w)
                    : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AutoTranslateText(
                  'Save Your Kundli Matching',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.textColorMaroon,
                    fontSize: 14.sp,
                    fontWeight: controller.saveMatchmakingChecked.value
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              Icon(
                Icons.bookmark_border,
                color: controller.saveMatchmakingChecked.value
                    ? AppColors.deepOrange
                    : AppColors.textSecondary.withValues(alpha: 0.5),
                size: 20.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPersonSection({
    required String label,
    required String subLabel,
    required TextEditingController nameController,
    required TextEditingController dateController,
    required TextEditingController timeController,
    required TextEditingController placeController,
    required VoidCallback onDateTap,
    required VoidCallback onTimeTap,
    required Function(Map<String, dynamic>) onPlaceSelected,
    required bool isPerson1,
  }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: '#68171E'.toColor().withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              AutoTranslateText(
                label,
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#68171E'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              Spacing.w(8),
              AutoTranslateText(
                subLabel,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#68171E'.toColor().withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          Spacing.h(16),
          _buildTextField(
            controller: nameController,
            label: 'Full Name',
            icon: Icons.person,
          ),
          Spacing.h(12),
          _buildTextField(
            controller: dateController,
            label: 'Birth Date',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: onDateTap,
          ),
          Spacing.h(12),
          _buildTextField(
            controller: timeController,
            label: 'Birth Time',
            icon: Icons.access_time,
            readOnly: true,
            onTap: onTimeTap,
          ),
          Spacing.h(12),
          AddressAutocompleteField(
            controller: placeController,
            onPlaceSelected: onPlaceSelected,
            country: 'in',
            decoration: InputDecoration(
              labelText: 'Birth Place',
              hintText: 'Enter birth place',
              labelStyle: MyTextTheme.smallBCN.copyWith(
                color: '#68171E'.toColor().withValues(alpha: 0.6),
              ),
              prefixIcon: Icon(
                Icons.location_on,
                color: AppColors.deepOrange,
                size: 20.w,
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 14.h,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(
                  color: '#68171E'.toColor().withValues(alpha: 0.2),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.r),
                borderSide: BorderSide(color: AppColors.deepOrange, width: 1.5),
              ),
            ),
          ),
          Spacing.h(8),
          AutoTranslateText(
            'Exact time improves accuracy',
            style: MyTextTheme.smallBCN
                .copyWith(color: '#68171E'.toColor().withValues(alpha: 0.6))
                .merge(AppTypography.label),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: TextFormField(
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        style: MyTextTheme.mediumBCN.copyWith(color: '#68171E'.toColor()),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: MyTextTheme.smallBCN.copyWith(
            color: '#68171E'.toColor().withValues(alpha: 0.6),
          ),
          prefixIcon: Icon(icon, color: AppColors.deepOrange, size: 20.w),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
            horizontal: 12.w,
            vertical: 14.h,
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Obx(
        () => DropdownButtonFormField<String>(
          value: controller.selectedLanguage.value,
          decoration: InputDecoration(
            labelText: 'Language',
            labelStyle: MyTextTheme.smallBCN.copyWith(
              color: '#68171E'.toColor().withValues(alpha: 0.6),
            ),
            prefixIcon: Icon(
              Icons.language,
              color: AppColors.deepOrange,
              size: 20.w,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: '#68171E'.toColor().withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(
                color: '#68171E'.toColor().withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
              borderSide: BorderSide(color: AppColors.deepOrange, width: 1.5),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 12.w,
              vertical: 14.h,
            ),
          ),
          items: controller.languages.entries.map((entry) {
            return DropdownMenuItem<String>(
              value: entry.key,
              child: AutoTranslateText(
                entry.value,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: '#68171E'.toColor(),
                ),
              ),
            );
          }).toList(),
          onChanged: (value) {
            if (value != null) {
              controller.selectedLanguage.value = value;
            }
          },
        ),
      ),
    );
  }

  Widget _buildCompareButton() {
    return Obx(
      () => GestureDetector(
        onTap: controller.isLoading.value
            ? null
            : () => controller.compareKundlis(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            gradient: controller.isLoading.value
                ? null
                : AppColors.orangeGradient,
            color: controller.isLoading.value ? Colors.grey[300] : null,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: controller.isLoading.value
                ? null
                : [
                    BoxShadow(
                      color: '#F38B3B'.toColor().withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (controller.isLoading.value)
                SizedBox(
                  width: 20.w,
                  height: 20.w,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              else ...[
                AutoTranslateText(
                  'Compare Kundlis',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacing.w(8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 20.w),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showDatePicker(BuildContext context, bool isPerson1) async {
    final pickedDate = await TimePickerHelper.showDatePicker(
      context,
      initialDate:
          (isPerson1
              ? controller.person1Date.value
              : controller.person2Date.value) ??
          DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      if (isPerson1) {
        controller.selectPerson1Date(pickedDate);
      } else {
        controller.selectPerson2Date(pickedDate);
      }
    }
  }

  void _showTimePicker(BuildContext context, bool isPerson1) async {
    final pickedTime = await TimePickerHelper.showTimePicker12h(
      context,
      initialTime: isPerson1
          ? (controller.person1Time.value ?? TimeOfDay.now())
          : (controller.person2Time.value ?? TimeOfDay.now()),
    );

    if (pickedTime != null) {
      if (isPerson1) {
        controller.selectPerson1Time(pickedTime);
      } else {
        controller.selectPerson2Time(pickedTime);
      }
    }
  }
}
