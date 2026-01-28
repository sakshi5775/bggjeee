import 'package:astrobharataiuser/app_manager/localized_text.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/localization/translations.dart' as AppTranslations;
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/data_model/comment_model.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

class CommentItem extends StatelessWidget {
  final Comment comment;
  const CommentItem({super.key, required this.comment});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: AppColors.saffron.withOpacity(0.15),
              child: Icon(Icons.person, size: 16, color: AppColors.saffron),
            ),
            Spacing.w(10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LocalizedText(
                    text: comment.userName ?? AppTranslations.Translations.user,
                    style: MyTextTheme.smallBCB.copyWith(
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Spacing.h(4),
                  LocalizedText(
                    text: comment.content ?? '',
                    style: MyTextTheme.smallBCN.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (comment.replies.isNotEmpty) ...[
          Spacing.h(8),
          Padding(
            padding: AppPaddings.only(left: 42),
            child: Column(
              children: comment.replies
                  .map((r) => Padding(
                        padding: AppPaddings.only(top: 8),
                        child: CommentItem(comment: r),
                      ))
                  .toList(),
            ),
          ),
        ],
      ],
    );
  }
}


