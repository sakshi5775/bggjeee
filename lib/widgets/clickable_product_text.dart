import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/utils/product_navigation_helper.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Widget that makes product names clickable with "Buy Now" links
class ClickableProductText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  const ClickableProductText({
    super.key,
    required this.text,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    // Check if text contains product types
    if (!ProductNavigationHelper.containsProductType(text)) {
      // No product types found, return regular text
      return AutoTranslateText(
        text,
        style: style,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      );
    }

    // Parse text and create clickable spans
    return _buildRichText(context);
  }

  Widget _buildRichText(BuildContext context) {
    final words = text.split(RegExp(r'(\s+)'));
    final spans = <TextSpan>[];

    for (final word in words) {
      final productType = ProductNavigationHelper.extractProductType(word);
      
      if (productType != null) {
        // Make product name clickable
        spans.add(
          TextSpan(
            text: word,
            style: (style ?? const TextStyle()).copyWith(
              color: AppColors.deepOrange,
              decoration: TextDecoration.underline,
              fontWeight: FontWeight.w600,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                ProductNavigationHelper.navigateToProductCategory(productType);
              },
          ),
        );
      } else {
        // Regular text
        spans.add(
          TextSpan(
            text: word,
            style: style,
          ),
        );
      }
    }

    return RichText(
      textAlign: textAlign ?? TextAlign.start,
      maxLines: maxLines,
      overflow: overflow ?? TextOverflow.clip,
      text: TextSpan(
        style: style ?? const TextStyle(),
        children: spans,
      ),
    );
  }
}

/// Widget that displays product name with a "Buy Now" button
class ProductSuggestionCard extends StatelessWidget {
  final String productName;
  final String? description;
  final String productType;

  const ProductSuggestionCard({
    super.key,
    required this.productName,
    this.description,
    required this.productType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.deepOrange.withValues(alpha: 0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AutoTranslateText(
                  productName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                  ),
                ),
                if (description != null && description!.isNotEmpty) ...[
                  SizedBox(height: 4.h),
                  AutoTranslateText(
                    description!,
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          GestureDetector(
            onTap: () {
              ProductNavigationHelper.navigateToProductCategory(productType);
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              decoration: BoxDecoration(
                gradient: AppColors.orangeGradient,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: AutoTranslateText(
                'Buy Now',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
