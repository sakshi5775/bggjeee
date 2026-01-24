import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/controller/lyrics_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/widgets/lyrics_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/widgets/lyrics_content_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/lyrics/widgets/lyrics_bottom_player_widget.dart';

class LyricsView extends GetView<LyricsController> {
  const LyricsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFFFE7A7),
              Color(0xFFFFF6E1),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const SizedBox(height: 10),
              const LyricsHeaderWidget(),
              const SizedBox(height: 20),
              const Expanded(
                child: LyricsContentWidget(),
              ),
              const LyricsBottomPlayerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
