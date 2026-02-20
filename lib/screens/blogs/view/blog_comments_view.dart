import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/localization/translations.dart'
    as AppTranslations;
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/blogs/controller/comments_controller.dart';
import 'package:astrobharataiuser/screens/blogs/widgets/comments/comment_item.dart';
import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BlogCommentsView extends StatelessWidget {
  final String blogId;
  const BlogCommentsView({super.key, required this.blogId});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CommentsController(blogId));
    return Scaffold(
      body: Column(
        children: [
          const CommonHeader(title: 'Comments'),
          Expanded(
            child: Padding(
              padding: AppPaddings.all(16),
              child: Obx(() {
                if (controller.loading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.comments.isEmpty) {
                  return Center(
                    child: LocalizedText(
                      text: AppTranslations.Translations.noCommentsFound,
                      style: MyTextTheme.smallBCN.copyWith(
                        color: '#3E2723'.toColor().withOpacity(0.7),
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
          ),
        ],
      ),
    );
  }
}
