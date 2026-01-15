import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_dashboard_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class QuoteOfTheDayWidget extends BasePage<UserDashboardController> {
  const QuoteOfTheDayWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final quote = controller.dailyQuote.value;
      final isFallback = quote?.isFallback ?? false;
      final title = isFallback ? 'Quote' : 'Quote of the Day';

      return Padding(
        padding: AppPaddings.symmetric(h: 16),
        child: AspectRatio(
          aspectRatio: 990 / 768, // keep full parchment visible
          child: Stack(
            children: [
              Container(
                padding: AppPaddings.symmetric(h: 20, v: 24),
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppConstant.quoteBackground),
                    fit: BoxFit.contain, // show entire image without cropping
                    alignment: Alignment.center,
                  ),
                  borderRadius: AppRadius.all(
                    0,
                  ), // avoid clipping edges of artwork
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    AutoTranslateText(
                      title,
                      style: MyTextTheme.mediumBCB
                          .copyWith(
                            color: "#6F221E".toColor(),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Baloo Bhai 2',
                          )
                          .merge(AppTypography.h3),
                      textAlign: TextAlign.center,
                    ),
                    AutoTranslateText(
                      quote?.sanskrit.text ?? '',
                      style: MyTextTheme.mediumBCB.copyWith(
                        color: "#F38B3B".toColor(),
                        fontWeight: FontWeight.w900,
                        fontFamily: 'Poppins',
                        fontSize: 12,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    Padding(
                      padding: AppPaddings.symmetric(h: 30),
                      child: AutoTranslateText(
                        quote?.sanskrit.meaning ?? '',
                        style: MyTextTheme.mediumBCN.copyWith(
                          color: "#551F23".toColor(),
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                          fontSize: 12,
                          height: 1.6,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 5,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}

