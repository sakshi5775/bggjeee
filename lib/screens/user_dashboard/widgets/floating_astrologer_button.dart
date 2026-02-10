import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../utils/app_colors.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';

class FloatingAstrologerButton extends StatefulWidget {
  const FloatingAstrologerButton({super.key});

  @override
  State<FloatingAstrologerButton> createState() =>
      _FloatingAstrologerButtonState();
}

class _FloatingAstrologerButtonState extends State<FloatingAstrologerButton>
    with SingleTickerProviderStateMixin {
  bool isOpen = false;

  @override
  Widget build(BuildContext context) {
    // Use Column instead of Stack so widget size grows to include children
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start, // Left aligned
      children: [
        if (isOpen) ...[
          _buildOptionButton(
            icon: Icons.chat,
            label: "Chat",
            onTap: () {
              setState(() => isOpen = false);
              Get.toNamed(AppRoutes.allAstrologers);
            },
          ),
          const SizedBox(height: 12),
          _buildOptionButton(
            icon: Icons.call,
            label: "Call",
            onTap: () {
              setState(() => isOpen = false);
              Get.toNamed(AppRoutes.allAstrologers);
            },
          ),
          const SizedBox(height: 16),
        ],
        Opacity(
          opacity: 0.8,
          child: Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              gradient: AppColors.orangeGradient,
              shape: BoxShape.circle,
              boxShadow: const [
                BoxShadow(color: Colors.black26, blurRadius: 6),
              ],
            ),
            child: FloatingActionButton(
              heroTag: 'floating_astrologer_btn',
              backgroundColor:
                  Colors.transparent, // Transparent to show gradient
              elevation: 0, // Remove shadow to blend with container
              onPressed: () {
                setState(() => isOpen = !isOpen);
              },
              child: AnimatedRotation(
                turns: isOpen ? 0.125 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(isOpen ? Icons.close : Icons.support_agent),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Opacity(
        opacity: 0.8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            gradient: AppColors.orangeGradient,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 6)],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
