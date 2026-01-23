import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/controller/meaning_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/meaning_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/meaning_content_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/meaning/widgets/meaning_bottom_player_widget.dart';

class MeaningView extends GetView<MeaningController> {
  const MeaningView({super.key});

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
              const MeaningHeaderWidget(),
              const SizedBox(height: 20),
              const Expanded(
                child: MeaningContentWidget(),
              ),
              const MeaningBottomPlayerWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
