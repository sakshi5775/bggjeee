import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/puja_detail/controller/puja_detail_controller.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PujaMediaCardWidget extends StatelessWidget {
  const PujaMediaCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PujaDetailController>();

    return Obx(() {
      final puja = controller.puja.value;
      if (puja == null) return const SizedBox.shrink();

      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Background image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: puja.image != null && puja.image!.isNotEmpty
                    ? Image.network(
                        puja.image!,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.image_not_supported,
                              size: 50,
                              color: Colors.grey,
                            ),
                          );
                        },
                      )
                    : Container(
                        color: Colors.grey[300],
                        child: const Icon(
                          Icons.image_not_supported,
                          size: 50,
                          color: Colors.grey,
                        ),
                      ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                  ),
                ),
              ),
              // Content overlay
              Positioned(
                left: 16,
                bottom: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Om symbol container
                    Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B5CF6), // Purple
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'ॐ',
                          style: TextStyle(
                            fontSize: 24,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AutoTranslateText(
                            puja.title ?? 'Puja',
                            style: MyTextTheme.veryLargeBCB.copyWith(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (puja.subheading != null && puja.subheading!.isNotEmpty) ...[
                            const SizedBox(height: 8),
                            AutoTranslateText(
                              puja.subheading!,
                              style: MyTextTheme.mediumBCN.copyWith(
                                color: Colors.white.withValues(alpha: 0.9),
                                fontSize: 14,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    // Play button
                    Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: Color(0xFF3E2723),
                        size: 24,
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
