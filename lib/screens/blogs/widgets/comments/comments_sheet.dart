import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/localization/translations.dart' as AppTranslations;
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/blogs/controller/comments_controller.dart';
import 'package:astrobharataiuser/screens/blogs/widgets/comments/comment_item.dart';


import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommentsSheet extends StatelessWidget {
  final String blogId;
  const CommentsSheet({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    // Use blogId as tag so each blog gets its own controller instance.
    final controller = Get.put(CommentsController(blogId), tag: blogId);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.lightBackground,
        borderRadius: AppRadius.only(topLeft: 20, topRight: 20),
      ),
      // SafeArea inside so the Container fills to the screen edge (no gap),
      // but the content still clears the system navigation bar.
      child: SafeArea(
        top: false,
        child: Padding(
        padding: AppPaddings.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.dividerLight,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Spacing.h(12),
            Row(
              children: [
                LocalizedText(
                  text: AppTranslations.Translations.comments,
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            Spacing.h(8),
            Expanded(
              child: Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.comments.isEmpty) {
                  return Center(
                    child: LocalizedText(
                      text: AppTranslations.Translations.noCommentsFound,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  );
                }
                return ListView.separated(
                  itemCount: controller.comments.length,
                  separatorBuilder: (_, __) => Spacing.h(12),
                  itemBuilder: (_, i) =>
                      CommentItem(comment: controller.comments[i]),
                );
              }),
            ),
            Spacing.h(8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textEditingController,
                    onChanged: (v) => controller.input.value = v,
                    decoration: InputDecoration(
                      hintText: AppTranslations.Translations.enterYourComment,
                      filled: true,
                      fillColor: AppColors.cardLight,
                      border: OutlineInputBorder(
                        borderRadius: AppRadius.all(12),
                        borderSide: BorderSide(color: AppColors.dividerLight),
                      ),
                      contentPadding: AppPaddings.symmetric(h: 12, v: 10),
                    ),
                  ),
                ),
                Spacing.w(10),
                Obx(
                  () => controller.submitting.value
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : IconButton(
                          onPressed: controller.input.value.trim().isEmpty
                              ? null
                              : () => controller.add(controller.input.value),
                          icon: Icon(
                            Icons.send,
                            color: controller.input.value.trim().isEmpty
                                ? AppColors.dividerLight
                                : AppColors.saffron,
                          ),
                        ),
                ),
              ],
            ),
          ],
        ),
        ), // Padding
      ), // SafeArea
    ); // Container
  }
}
