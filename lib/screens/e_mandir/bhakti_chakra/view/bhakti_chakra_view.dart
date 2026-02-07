import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/controller/bhakti_chakra_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/bhakti_chakra_list_widget.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';

class BhaktiChakraView extends GetView<BhaktiChakraController> {
  const BhaktiChakraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            const CommonHeader(title: 'Bhakti Chakra'),
            Expanded(child: BhaktiChakraListWidget()),
          ],
        ),
      ),
    );
  }
}
