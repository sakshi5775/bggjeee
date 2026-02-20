import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/core/localization/language_controller_v2.dart';
import 'package:astrobharataiuser/core/services/custom_translation_service.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

/// Language selector widget that can be used in settings or profile
class LanguageSelectorWidget extends StatelessWidget {
  final bool showTitle;
  const LanguageSelectorWidget({super.key, this.showTitle = true});

  @override
  Widget build(BuildContext context) {
    final languageController = Get.find<LanguageControllerV2>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (showTitle) ...[
          GetBuilder<CustomTranslationService>(
            builder: (translationService) => AutoTranslateText(
              translationService.tr('profile.selectLanguage'),
              style: MyTextTheme.largeBCB.copyWith(color: AppColors.textPrimary),
            ),
          ),
          Spacing.h(16),
        ],
        FutureBuilder<List<AppLanguageModel>>(
          future: LanguageModelService.getLanguages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError || !snapshot.hasData) {
              return const SizedBox.shrink();
            }
            return Obx(() => _buildLanguageList(
                  languageController,
                  snapshot.data!,
                ));
          },
        ),
      ],
    );
  }

  Widget _buildLanguageList(
      LanguageControllerV2 controller, List<AppLanguageModel> languages) {
    return Column(
      children: languages.map((language) {
        final isSelected = controller.currentLanguage.value?.code == language.code;
        return GestureDetector(
          onTap: () => controller.changeLanguage(language),
          child: Container(
            margin: AppMargin.only(bottom: 12),
            padding: AppPaddings.all(16),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.saffron.withValues(alpha: 0.1)
                  : AppColors.cardLight,
              borderRadius: AppRadius.all(12),
              border: Border.all(
                color: isSelected ? AppColors.saffron : AppColors.dividerLight,
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 4.r,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.saffron
                        : AppColors.textSecondary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Center(
                    child: AutoTranslateText(
                      language.code.toUpperCase(),
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: isSelected
                            ? AppColors.textLight
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ),
                Spacing.w(16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      AutoTranslateText(
                        language.nameEn,
                        style: MyTextTheme.mediumBCB.copyWith(
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Spacing.h(4),
                      AutoTranslateText(
                        language.nameNative,
                        style: MyTextTheme.smallBCN.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle,
                    color: AppColors.saffron,
                    size: 24.h,
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

/// Language selector dialog
class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: AppRadius.all(16)),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        padding: AppPaddings.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GetBuilder<CustomTranslationService>(
                    builder: (translationService) => AutoTranslateText(
                      translationService.tr('profile.selectLanguage'),
                      style: MyTextTheme.largeBCB.copyWith(
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ],
            ),
            Spacing.h(16),
            Expanded(
              child: SingleChildScrollView(
                child: const LanguageSelectorWidget(showTitle: false),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void show() {
    Get.dialog(const LanguageSelectorDialog());
  }
}


