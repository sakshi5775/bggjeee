import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:astrobharataiuser/screens/ramal_shastra/controller/ramal_shastra_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class RamalShastraCastingCardsView extends StatefulWidget {
  const RamalShastraCastingCardsView({Key? key}) : super(key: key);

  @override
  State<RamalShastraCastingCardsView> createState() =>
      _RamalShastraCastingCardsViewState();
}

class _RamalShastraCastingCardsViewState
    extends State<RamalShastraCastingCardsView> {
  final RamalShastraController controller = Get.find<RamalShastraController>();
  final List<bool> cardResults = List.generate(
    16,
    (_) => false,
  ); // Red = true, Black = false
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Ramal Shastra'),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Spacing.h(24),
                    AutoTranslateText(
                      'Draw 16 Cards',
                      style: MyTextTheme.veryLargeBCB
                          .copyWith(
                            color: '#3E2723'.toColor(),
                            fontWeight: FontWeight.bold,
                          )
                          .merge(AppTypography.h1),
                    ),
                    Spacing.h(8),
                    AutoTranslateText(
                      'Card ${currentIndex + 1} of 16',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: '#666666'.toColor(),
                      ),
                    ),
                    Spacing.h(32),
                    // Card Grid
                    _buildCardGrid(),
                    Spacing.h(32),
                    if (currentIndex < 16)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            onPressed: () => _drawCard(true),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32.w,
                                vertical: 14.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: AutoTranslateText(
                              'Red Card',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Spacing.w(16),
                          ElevatedButton(
                            onPressed: () => _drawCard(false),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(
                                horizontal: 32.w,
                                vertical: 14.h,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            child: AutoTranslateText(
                              'Black Card',
                              style: MyTextTheme.mediumBCB.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                    else
                      ElevatedButton(
                        onPressed: () {
                          controller.generatePointsFromCards(cardResults);
                          Get.toNamed(AppRoutes.ramalShastraConfirmation);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: '#4CAF50'.toColor(),
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                            horizontal: 32.w,
                            vertical: 14.h,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: AutoTranslateText(
                          'Confirm & Proceed',
                          style: MyTextTheme.mediumBCB.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    Spacing.h(32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCardGrid() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 8.w,
          mainAxisSpacing: 8.h,
        ),
        itemCount: 16,
        itemBuilder: (context, index) {
          final isDrawn = index < currentIndex;
          final isRed = isDrawn ? cardResults[index] : null;

          return Container(
            decoration: BoxDecoration(
              color: isDrawn
                  ? (isRed! ? Colors.red : Colors.black87)
                  : Colors.grey[300],
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(
                color: index == currentIndex
                    ? "#F38B3B".toColor()
                    : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: isDrawn
                  ? Icon(Icons.style, color: Colors.white, size: 24.w)
                  : Icon(
                      Icons.help_outline,
                      color: Colors.grey[600],
                      size: 24.w,
                    ),
            ),
          );
        },
      ),
    );
  }

  void _drawCard(bool isRed) {
    if (currentIndex < 16) {
      setState(() {
        cardResults[currentIndex] = isRed;
        currentIndex++;
      });
    }
  }
}
