import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/controller/passbook_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/widgets/passbook_header_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/passbook/widgets/passbook_list_widget.dart';

class PassbookView extends GetView<PassbookController> {
  const PassbookView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF3DC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              const SizedBox(height: 10),
              const PassbookHeaderWidget(),
              const SizedBox(height: 10),
              Expanded(
                child: PassbookListWidget(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
