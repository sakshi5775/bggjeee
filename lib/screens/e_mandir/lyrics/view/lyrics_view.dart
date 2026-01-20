import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/controller/lyrics_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/widgets/lyrics_bottom_player_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/widgets/lyrics_card_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/widgets/lyrics_header_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LyricsView extends BasePage<LyricsController> {
  const LyricsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(gradient: AppColors.gradientBackground),
        child: SafeArea(
          child: Column(
            children: [
              Spacing.h(10),
              const LyricsHeaderWidget(),
              Spacing.h(20),
              const LyricsCardWidget(),
              const LyricsBottomPlayerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
