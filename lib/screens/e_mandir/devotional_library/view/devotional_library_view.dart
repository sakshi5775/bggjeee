import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/controller/devotional_library_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_tabs_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/devotional_library/widgets/devotional_list_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';

class DevotionalLibraryView extends GetView<DevotionalLibraryController> {
  const DevotionalLibraryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CommonHeader(title: 'Devotional Library'),
            const SizedBox(height: 16),
            const DevotionalTabsWidget(),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: DevotionalListWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
