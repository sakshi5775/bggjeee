import 'package:astrobharataiuser/screens/e_mandir/namaste_home_screen/controller/namaste_home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LiveDarshanSectionWidget extends StatelessWidget {
  const LiveDarshanSectionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NamasteHomeController>();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PageView.builder(
            controller: controller.darshanController,
            itemCount: controller.darshanImages.length,
            onPageChanged: controller.onDarshanPageChanged,
            itemBuilder: (context, index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(controller.darshanImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              controller.darshanImages.length,
              (index) => AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                height: controller.currentDarshanIndex.value == index ? 15 : 12,
                width: controller.currentDarshanIndex.value == index ? 15 : 12,
                decoration: BoxDecoration(
                  color: controller.currentDarshanIndex.value == index
                      ? Colors.deepOrange
                      : Colors.grey.shade400,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
