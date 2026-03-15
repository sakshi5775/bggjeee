import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/base_controller.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/kundli/controller/kundli_form_controller.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/panchang/widgets/location_bottom_sheet_widget.dart';
import 'package:astrobharataiuser/screens/user_dashboard/view/user_dashboard_view.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/time_picker_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class KundliFormView extends BasePage<KundliFormController> {
  const KundliFormView({super.key});

  // Persistent form key to prevent rebuilds from losing focus
  static final _formKey = GlobalKey<FormState>();
  
  // Focus node for name field to maintain focus
  static final _nameFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        // drawer: UserDashboardView.buildDrawer(context),
        body: Column(
          children: [
            const CommonHeader(title: 'Kundli', showEndDrawer: false),
            // Tab Bar
            _buildTabBar(),
            // Tab Content
            Expanded(
              child: Obx(() {
                if (controller.selectedTabIndex.value == 0) {
                  return _buildSavedKundliTab();
                } else {
                  return _buildFormContent();
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
            _buildTabItem('Saved Kundli', 0),
            _buildTabItem('New Kundli', 1),
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

  // ===== Saved Kundli Tab =====
  Widget _buildSavedKundliTab() {
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
                hintText: 'Search kundli by name',
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
          child: Builder(
            builder: (context) => Obx(() {
            if (controller.isLoadingSavedKundli.value) {
              return Center(
                child: CircularProgressIndicator(color: AppColors.deepOrange),
              );
            }
            final list = controller.filteredKundliList;
            if (list.isEmpty) {
              return _buildEmptyState();
            }
            return Stack(
              children: [
                RefreshIndicator(
                  color: AppColors.deepOrange,
                  onRefresh: () => controller.fetchSavedKundliProfiles(),
                  child: ListView.builder(
                      padding: EdgeInsets.only(
                        left: 16.w,
                        right: 16.w,
                        top: 4.h,
                        bottom: 4.h + 70.h + MediaQuery.of(context).padding.bottom,
                    ),
                    itemCount: list.length,
                    itemBuilder: (context, index) {
                      return _buildSavedKundliCard(list[index]);
                    },
                  ),
                ),
                // Loading overlay when opening a saved kundli
                Obx(() {
                  if (controller.isOpeningSavedKundli.value) {
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
                                'Generating Kundli...',
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
            Icons.auto_awesome,
            color: AppColors.deepOrange.withValues(alpha: 0.4),
            size: 64.w,
          ),
          SizedBox(height: 16.h),
          AutoTranslateText(
            'No saved kundli found',
            style: MyTextTheme.mediumBCB.copyWith(
              color: AppColors.textSecondary,
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 8.h),
          AutoTranslateText(
            'Create a new kundli to get started',
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
                'Create New Kundli',
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

  Widget _buildSavedKundliCard(Map<String, dynamic> profile) {
    final name = profile['name'] ?? 'Unknown';
    final dob = profile['dateOfBirth'] ?? '';
    final birthTime = profile['birthTime'] ?? '';
    final birthPlace = profile['birthPlace'] ?? '';
    final firstLetter = name.isNotEmpty ? name[0].toUpperCase() : '?';

    // Format date for display
    String displayDate = dob;
    try {
      if (dob.isNotEmpty) {
        final parts = dob.split('/');
        if (parts.length == 3) {
          final month = int.parse(parts[0]);
          final day = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          displayDate = DateFormat(
            'dd-MMM-yyyy',
          ).format(DateTime(year, month, day));
        }
      }
    } catch (e) {
      // Use raw format
    }

    return GestureDetector(
      onTap: () => controller.openSavedKundli(profile),
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
            // Avatar
            Container(
              width: 48.w,
              height: 48.w,
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  firstLetter,
                  style: MyTextTheme.largeBCB.copyWith(
                    color: Colors.white,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: MyTextTheme.mediumBCB.copyWith(
                      color: AppColors.textColorMaroon,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '$displayDate, $birthTime',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (birthPlace.isNotEmpty) ...[
                    SizedBox(height: 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          color: AppColors.deepOrange,
                          size: 13.w,
                        ),
                        SizedBox(width: 3.w),
                        Expanded(
                          child: Text(
                            birthPlace,
                            style: MyTextTheme.smallBCN.copyWith(
                              color: AppColors.textSecondary.withValues(
                                alpha: 0.7,
                              ),
                              fontSize: 11.sp,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
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
                    controller.openSavedKundli(profile);
                    break;
                  case 'edit':
                    controller.editSavedKundli(profile);
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
                        'View Kundli',
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
                        'Edit Kundli',
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
                        'Delete Kundli',
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
    final name = profile['name'] ?? 'this kundli';
    final id = profile['_id']?.toString();
    if (id == null) return;

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        title: AutoTranslateText(
          'Delete Kundli',
          style: MyTextTheme.largeBCB.copyWith(
            color: AppColors.textColorMaroon,
            fontSize: 18.sp,
          ),
        ),
        content: AutoTranslateText(
          'Are you sure you want to delete "$name"? This action cannot be undone.',
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
              controller.deleteSavedKundliProfile(id);
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

  // ===== Form Section (New Kundli Tab) =====

  BoxDecoration _formCardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: AppColors.deepOrange.withValues(alpha: 0.2),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.deepOrange.withValues(alpha: 0.08),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    Widget? suffix,
  }) {
    return InputDecoration(
      isDense: true,
      contentPadding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 14.w),
      hintText: hint,
      hintStyle: MyTextTheme.smallBCN.copyWith(
        color: AppColors.textSecondary.withValues(alpha: 0.6),
        fontSize: 13.sp,
      ),
      prefixIcon: Padding(
        padding: EdgeInsets.only(left: 12.w, right: 8.w),
        child: Icon(icon, color: AppColors.deepOrange, size: 20.w),
      ),
      suffixIcon: suffix,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: AppColors.deepOrange.withValues(alpha: 0.2),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(
          color: AppColors.deepOrange.withValues(alpha: 0.2),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: AppColors.deepOrange, width: 1.5),
      ),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _buildFormContent() {
    return Builder(
      builder: (context) => SingleChildScrollView(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          top: 0.h,
          bottom: 16.h + 70.h + MediaQuery.of(context).padding.bottom,
        ),
        child: _buildFormSection(),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      decoration: _formCardDecoration(),
      padding: EdgeInsets.all(16.w),
      child: Form(
        key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: ShaderMask(
              blendMode: BlendMode.srcIn,
              shaderCallback: (bounds) =>
                  AppColors.orangeGradient.createShader(bounds),
              child: AutoTranslateText(
                'Generate your Kundli, get your predictions',
                style: MyTextTheme.mediumBCB.copyWith(
                  fontSize: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Spacing.h(16),
          // Full Name - separate row
          _buildCompactField(
            controller: controller.nameController,
            focusNode: _nameFocusNode,
            hint: 'Full Name',
            icon: Icons.person_outline,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please enter full name';
              }
              return null;
            },
          ),
          Spacing.h(12),
          // Gender - separate row
          SizedBox(height: 50.h, child: _buildGenderDropdown()),
          Spacing.h(12),
          // DOB - separate row
          _buildCompactField(
            controller: controller.dateController,
            hint: 'DOB (dd/mm/yyyy)',
            icon: Icons.calendar_today,
            readOnly: true,
            onTap: () => _showDatePicker(),
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Please select date';
              }
              return null;
            },
          ),
          Spacing.h(12),
          // Time of Birth - separate row
          _buildTimeField(),
          Spacing.h(6),
          Padding(
            padding: EdgeInsets.only(left: 4.w),
            child: AutoTranslateText(
              'Accurate birth time improves Kundli accuracy.',
              style: MyTextTheme.smallBCN.copyWith(
                color: AppColors.textSecondary.withValues(alpha: 0.7),
                fontSize: 11.sp,
              ),
            ),
          ),
          Spacing.h(12),
          _buildCompactLocation(),
          Spacing.h(12),
          Row(
            children: [
              Expanded(child: _buildLanguageDropdown()),
              SizedBox(width: 10.w),
              Expanded(child: _buildStyleDropdown()),
            ],
          ),
          Spacing.h(16),
          // Save Your Kundli checkbox
          _buildSaveCheckbox(),
          Spacing.h(16),
          _buildSubmitButton(_formKey),
        ],
      ),
      ),
    );
  }

  // ===== Save Kundli Checkbox =====
  Widget _buildSaveCheckbox() {
    return Obx(
      () => GestureDetector(
        onTap: () => controller.saveKundliChecked.toggle(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: controller.saveKundliChecked.value
                ? AppColors.deepOrange.withValues(alpha: 0.08)
                : Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: controller.saveKundliChecked.value
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
                  color: controller.saveKundliChecked.value
                      ? AppColors.deepOrange
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(6.r),
                  border: Border.all(
                    color: controller.saveKundliChecked.value
                        ? AppColors.deepOrange
                        : AppColors.textSecondary.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                ),
                child: controller.saveKundliChecked.value
                    ? Icon(Icons.check, color: Colors.white, size: 16.w)
                    : null,
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: AutoTranslateText(
                  'Save Your Kundli',
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: AppColors.textColorMaroon,
                    fontSize: 14.sp,
                    fontWeight: controller.saveKundliChecked.value
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
              Icon(
                Icons.bookmark_border,
                color: controller.saveKundliChecked.value
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

  /// Birth time field showing 12-hour AM/PM; timeController still holds 24h for API.
  Widget _buildTimeField() {
    return Obx(() {
      final t = controller.selectedTime.value;
      final display = TimePickerHelper.formatTime24To12Display(
        t.hour,
        t.minute,
      );
      return GestureDetector(
        onTap: () => _showTimePicker(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.deepOrange.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: InputDecorator(
            decoration: _inputDecoration(
              hint: 'Birth Time',
              icon: Icons.access_time,
              suffix: Padding(
                padding: EdgeInsets.only(right: 10.w),
                child: Icon(
                  Icons.arrow_forward_ios,
                  color: AppColors.deepOrange,
                  size: 12.w,
                ),
              ),
            ),
            child: Text(
              display,
              style: MyTextTheme.mediumBCN.copyWith(
                color: AppColors.textColorMaroon,
              ),
            ),
          ),
        ),
      );
    });
  }

  Widget _buildCompactField({
    required TextEditingController controller,
    FocusNode? focusNode,
    required String hint,
    required IconData icon,
    bool readOnly = false,
    VoidCallback? onTap,
    String? Function(String?)? validator,
  }) {
    return Material(
      color: Colors.transparent,
      child: Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
          focusNode: focusNode,
        readOnly: readOnly,
          enabled: !readOnly || onTap != null,
        onTap: onTap,
          validator: validator,
          keyboardType: readOnly ? null : TextInputType.text,
          textInputAction: TextInputAction.next,
        style: MyTextTheme.mediumBCN.copyWith(color: AppColors.textColorMaroon),
        decoration: _inputDecoration(
          hint: hint,
          icon: icon,
          suffix: readOnly && onTap != null
              ? Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.deepOrange,
                    size: 12.w,
                  ),
                )
              : null,
          ),
        ),
      ),
    );
  }

  Widget _buildCompactLocation() {
    return Obx(
      () => GestureDetector(
      onTap: () => _showLocationBottomSheet(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
              color: controller.selectedLocation.value == 'Select Location' ||
                      controller.selectedLocation.value == 'Fetching Location...'
                  ? AppColors.error.withValues(alpha: 0.3)
                  : AppColors.deepOrange.withValues(alpha: 0.2),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.location_on, color: AppColors.deepOrange, size: 20.w),
            SizedBox(width: 10.w),
            Expanded(
                child: AutoTranslateText(
                  controller.selectedLocation.value,
                  style: MyTextTheme.mediumBCN.copyWith(
                    color: controller.selectedLocation.value == 'Select Location' ||
                            controller.selectedLocation.value == 'Fetching Location...'
                        ? AppColors.textSecondary.withValues(alpha: 0.6)
                        : AppColors.textColorMaroon,
                  ),
                  overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.chevron_right, color: AppColors.deepOrange, size: 22.w),
          ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderDropdown() {
    return Obx(
      () => _buildCompactDropdown<String>(
        value: controller.selectedGender.value,
        hint: 'Gender',
        icon: Icons.person_outline,
        items: controller.genderOptions
            .map((g) => DropdownMenuItem(value: g, child: AutoTranslateText(g)))
            .toList(),
        onChanged: (v) {
          if (v != null) controller.selectedGender.value = v;
        },
        selectedItemBuilder: (context) => controller.genderOptions
            .map(
              (g) => AutoTranslateText(
                g,
                style: MyTextTheme.mediumBCN.copyWith(
                  color: AppColors.textColorMaroon,
                ),
              ),
            )
            .toList(),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select gender';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildLanguageDropdown() {
    return Obx(
      () => _buildCompactDropdown<String>(
        value: controller.selectedLanguage.value,
        hint: 'Language',
        icon: Icons.language,
        items: controller.languages.entries
            .map(
              (e) => DropdownMenuItem(
                value: e.key,
                child: AutoTranslateText(e.value),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null) controller.selectedLanguage.value = v;
        },
      ),
    );
  }

  Widget _buildStyleDropdown() {
    return Obx(
      () => _buildCompactDropdown<String>(
        value: controller.selectedStyle.value,
        hint: 'Chart Style',
        icon: Icons.style,
        items: controller.styles
            .map(
              (s) => DropdownMenuItem(
                value: s,
                child: AutoTranslateText(s.toUpperCase()),
              ),
            )
            .toList(),
        onChanged: (v) {
          if (v != null) controller.selectedStyle.value = v;
        },
      ),
    );
  }

  Widget _buildCompactDropdown<T>({
    required T? value,
    required String hint,
    required IconData icon,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
    List<Widget> Function(BuildContext)? selectedItemBuilder,
    String? Function(T?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.deepOrange.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        hint: AutoTranslateText(
          hint,
          style: MyTextTheme.smallBCN.copyWith(
            color: AppColors.textSecondary.withValues(alpha: 0.6),
            fontSize: 13.sp,
          ),
        ),
        decoration: _inputDecoration(
          hint: hint,
          icon: icon,
          suffix: Icon(
            Icons.arrow_drop_down,
            color: AppColors.deepOrange,
            size: 24.w,
          ),
        ),
        isExpanded: true,
        items: items,
        onChanged: onChanged,
        selectedItemBuilder: selectedItemBuilder,
        validator: validator,
      ),
    );
  }

  Widget _buildSubmitButton(GlobalKey<FormState> formKey) {
    return Obx(
      () => Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: AppColors.deepOrange.withValues(alpha: 0.2),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: controller.isLoading.value
              ? null
              : () {
                  if (formKey.currentState?.validate() ?? false) {
                    controller.generateKundli();
                  }
                },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.zero,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16.r),
            ),
            elevation: 0,
          ),
          child: Ink(
            decoration: BoxDecoration(
              gradient: controller.isLoading.value
                  ? LinearGradient(
                      colors: [
                        AppColors.deepOrange.withValues(alpha: 0.5),
                        AppColors.templeGold.withValues(alpha: 0.5),
                      ],
                    )
                  : AppColors.orangeGradient,
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Container(
              alignment: Alignment.center,
              child: controller.isLoading.value
                  ? SizedBox(
                      height: 24.h,
                      width: 24.w,
                      child: const CircularProgressIndicator(
                        strokeWidth: 3,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppColors.white,
                          size: 22.w,
                        ),
                        SizedBox(width: 12.w),
                        AutoTranslateText(
                          'Generate Kundli',
                          style: MyTextTheme.largeBCB.copyWith(
                            color: AppColors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18.sp,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final pickedDate = await TimePickerHelper.showDatePicker(
      Get.context!,
      initialDate: controller.selectedDate.value,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      controller.selectDate(pickedDate);
    }
  }

  void _showTimePicker() async {
    final pickedTime = await TimePickerHelper.showTimePicker12h(
      Get.context!,
      initialTime: controller.selectedTime.value,
    );

    if (pickedTime != null) {
      controller.selectTime(pickedTime);
    }
  }

  void _showLocationBottomSheet() {
    Get.bottomSheet(
      Container(
        height: Get.height * 0.8,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r),
            topRight: Radius.circular(24.r),
          ),
        ),
        child: LocationBottomSheetWidget(
          onCitySelected:
              (city, state, country, [latitude, longitude, timezone]) {
                controller.selectCity(city, state, country);
                Get.back();
              },
          selectedCity: controller.selectedLocation.value,
          onUseCurrentLocation: () => controller.getCurrentLocation(),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}
