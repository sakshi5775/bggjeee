import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:astrobharataiuser/widgets/common_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VastuShastraView extends StatelessWidget {
  const VastuShastraView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppColors.gradientBackground),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Padding(
          padding: EdgeInsets.only(
            top:
                (MediaQuery.of(context).padding.top > 0
                        ? MediaQuery.of(context).padding.top * 0.5
                        : 0.0)
                    .clamp(6.0, 24.0)
                    .toDouble(),
          ),
          child: Column(
            children: [
              CommonHeader(title: 'Vastu Shastra'),
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacing.h(8),
                      AutoTranslateText(
                        'Ancient wisdom for harmonious living',
                        style: MyTextTheme.mediumBCN
                            .copyWith(color: '#666666'.toColor())
                            .merge(AppTypography.body1),
                      ),
                      Spacing.h(24),
                      _buildPrincipleCard(
                        'The Five Elements',
                        'Vastu Shastra is based on the balance of five elements: Earth, Water, Fire, Air, and Space. Each direction is associated with specific elements.',
                        [
                          'Earth (Prithvi): Southwest, stability and grounding',
                          'Water (Jal): Northeast, flow and prosperity',
                          'Fire (Agni): Southeast, energy and transformation',
                          'Air (Vayu): Northwest, movement and communication',
                          'Space (Akash): Center, consciousness and expansion',
                        ],
                        Icons.auto_awesome,
                      ),
                      Spacing.h(16),
                      _buildPrincipleCard(
                        'Eight Directions',
                        'Each of the eight directions has specific characteristics and influences different aspects of life.',
                        [
                          'North: Wealth, career, and opportunities',
                          'Northeast: Sacred zone, knowledge, spirituality',
                          'East: Health, sunrise energy, new beginnings',
                          'Southeast: Fire element, kitchen, energy',
                          'South: Fame, recognition, relationships',
                          'Southwest: Stability, strength, master bedroom',
                          'West: Creativity, children, water features',
                          'Northwest: Air element, movement, guest room',
                        ],
                        Icons.explore,
                      ),
                      Spacing.h(16),
                      _buildPrincipleCard(
                        'Center (Brahmasthan)',
                        'The center of the house is the most sacred area, representing the cosmic energy point.',
                        [
                          'Keep center area open and uncluttered',
                          'Avoid heavy furniture or structures',
                          'Ideal for courtyard or open space',
                          'Maintain cleanliness and positive energy',
                          'No toilets, kitchens, or stairs in center',
                        ],
                        Icons.center_focus_strong,
                      ),
                      Spacing.h(16),
                      _buildPrincipleCard(
                        'Energy Flow',
                        'Vastu emphasizes the flow of positive energy (Prana) throughout the space.',
                        [
                          'Ensure free flow of air and light',
                          'Avoid sharp corners pointing at living areas',
                          'Maintain balance between open and closed spaces',
                          'Use colors that enhance positive energy',
                          'Keep pathways clear and unobstructed',
                        ],
                        Icons.waves,
                      ),
                      Spacing.h(16),
                      _buildPrincipleCard(
                        'Room Placement Principles',
                        'Each room has an ideal direction based on its function and energy requirements.',
                        [
                          'Kitchen: Southeast (fire element)',
                          'Bedroom: Southwest or South (stability)',
                          'Bathroom: Northwest or West (water element)',
                          'Pooja Room: Northeast (sacred zone)',
                          'Study Room: North or East (knowledge)',
                          'Living Room: North or East (positive energy)',
                        ],
                        Icons.home,
                      ),
                      Spacing.h(16),
                      _buildPrincipleCard(
                        'Color Psychology',
                        'Colors play a vital role in Vastu, affecting mood and energy levels.',
                        [
                          'North: White, light blue (water element)',
                          'Northeast: White, yellow (sacred)',
                          'East: Green, light yellow (sunrise)',
                          'Southeast: Red, orange (fire)',
                          'South: Red, pink (fire element)',
                          'Southwest: Brown, earth tones (stability)',
                          'West: White, silver (water)',
                          'Northwest: White, gray (air)',
                        ],
                        Icons.palette,
                      ),
                      Spacing.h(16),
                      _buildPrincipleCard(
                        'Entrance Principles',
                        'The main entrance is the gateway for energy to enter your home.',
                        [
                          'Ideal directions: North, East, or Northeast',
                          'Entrance should be larger than other doors',
                          'Avoid entrance facing South or Southwest',
                          'Keep entrance well-lit and welcoming',
                          'Place auspicious symbols near entrance',
                          'Ensure smooth, unobstructed pathway',
                        ],
                        Icons.home,
                      ),
                      Spacing.h(24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPrincipleCard(
    String title,
    String description,
    List<String> points,
    IconData icon,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: '#ffffff'.toColor(),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: '#F3E5F5'.toColor(), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: '#F3E5F5'.toColor(),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(icon, color: '#9B59B6'.toColor(), size: 24.w),
              ),
              Spacing.w(12),
              Expanded(
                child: AutoTranslateText(
                  title,
                  style: MyTextTheme.largeBCB
                      .copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      )
                      .merge(AppTypography.h2),
                ),
              ),
            ],
          ),
          Spacing.h(12),
          AutoTranslateText(
            description,
            style: MyTextTheme.mediumBCN
                .copyWith(color: '#666666'.toColor())
                .merge(AppTypography.body1),
          ),
          Spacing.h(16),
          ...points.map(
            (point) => Padding(
              padding: EdgeInsets.only(bottom: 8.h),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.circle, color: '#9B59B6'.toColor(), size: 8.w),
                  Spacing.w(8),
                  Expanded(
                    child: AutoTranslateText(
                      point,
                      style: MyTextTheme.smallBCN
                          .copyWith(color: '#666666'.toColor())
                          .merge(AppTypography.body2),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
