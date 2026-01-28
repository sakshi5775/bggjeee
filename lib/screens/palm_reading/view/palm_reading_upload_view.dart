import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/screens/palm_reading/controller/palm_reading_controller.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PalmReadingUploadView extends StatelessWidget {
  const PalmReadingUploadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PalmReadingController>();
    final isMobile = MediaQuery.of(context).size.width < 768;
    final maxWidth = isMobile ? double.infinity : 500.w;

    return Scaffold(
      backgroundColor: '#FFF8E1'.toColor(), // Match face reading background
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: maxWidth),
                  child: Padding(
                    padding: AppPaddings.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // Back button
                    GestureDetector(
                      onTap: () => Get.back(),
                      child: Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.arrow_back,
                          color: '#3E2723'.toColor(),
                          size: 20.w,
                        ),
                      ),
                    ),
                    
                    Spacing.h(24),
                    
                    // Title
                    AutoTranslateText(
                      'Upload Palm Photo',
                      style: MyTextTheme.veryLargeBCB.copyWith(
                        color: '#3E2723'.toColor(),
                        fontWeight: FontWeight.bold,
                      ).merge(AppTypography.h1),
                    ),
                    
                    Spacing.h(8),
                    
                    // Subtitle
                    AutoTranslateText(
                      'Take a clear photo of your palm for accurate reading',
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: Colors.grey[700],
                      ),
                    ),
                    
                    Spacing.h(32),
                    
                    // Upload Method Card
                    _buildUploadMethodCard(context, controller),
                    
                    Spacing.h(32),
                    
                    // Photo Guidelines Section
                    _buildPhotoGuidelinesSection(),
                    
                    Spacing.h(32),
                    
                    // Palm Analysis Section (shown when image is uploaded)
                    Obx(() => controller.selectedPalmImage.value != null
                        ? _buildPalmAnalysisSection(controller)
                        : const SizedBox.shrink()),
                    
                    if (controller.selectedPalmImage.value != null) Spacing.h(32),
                    
                    // Continue button
                    Obx(() => _buildContinueButton(context, controller)),
                    
                    Spacing.h(32),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadMethodCard(BuildContext context, PalmReadingController controller) {
    return Obx(() {
      final hasImage = controller.selectedPalmImage.value != null;
      
      return Container(
        padding: AppPaddings.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: '#F5D7B8'.toColor(),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            if (hasImage) ...[
              // Show selected image
              Container(
                width: double.infinity,
                height: 300.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: "#F38B3B".toColor(),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: Image.file(
                    controller.selectedPalmImage.value!,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Spacing.h(16),
              // Change photo button
              TextButton.icon(
                onPressed: () => controller.selectedPalmImage.value = null,
                icon: Icon(Icons.refresh, color: '#EA632B'.toColor(), size: 20.w),
                label: AutoTranslateText(
                  'Change Photo',
                  style: MyTextTheme.mediumBCB.copyWith(
                    color: '#EA632B'.toColor(),
                  ),
                ),
              ),
             ] else ...[
               // Icon with palmscan.png
               SizedBox(
                 height: 120.h,
                 child: Center(
                   child: Transform.scale(
                     scale: 1.6,
                     child: Image.network(
                       AppConstant.palmscan,
                       fit: BoxFit.contain,
                       loadingBuilder: (context, child, loadingProgress) {
                         if (loadingProgress == null) return child;
                         return const Center(child: CircularProgressIndicator());
                       },
                       errorBuilder: (context, error, stackTrace) {
                         return const Center(child: Icon(Icons.error));
                       },
                     ),
                   ),
                 ),
               ),
               
               Spacing.h(20),
              
              AutoTranslateText(
                'Choose Upload Method',
                style: MyTextTheme.mediumBCB.copyWith(
                  color: '#3E2723'.toColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              Spacing.h(2),
              
              // Take Photo button
              _buildUploadButton(
                context: context,
                controller: controller,
                label: 'Take Photo',
                icon: Icons.camera_alt,
                isPrimary: true,
                onTap: () => controller.takePhoto(context),
              ),
              
              Spacing.h(12),
              
              // Upload from Gallery button
              _buildUploadButton(
                context: context,
                controller: controller,
                label: 'Upload from Gallery',
                icon: Icons.photo_library,
                isPrimary: false,
                onTap: () => controller.uploadFromGallery(context),
              ),
            ],
          ],
        ),
      );
    });
  }

  Widget _buildUploadButton({
    required BuildContext context,
    required PalmReadingController controller,
    required String label,
    required IconData icon,
    required bool isPrimary,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(
          icon,
          color: isPrimary ? Colors.white : '#3E2723'.toColor(),
          size: 20.w,
        ),
        label: AutoTranslateText(
          label,
          style: MyTextTheme.mediumBCB.copyWith(
            color: isPrimary ? Colors.white : '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isPrimary
              ? "#F38B3B".toColor()
              : Colors.white,
          foregroundColor: isPrimary
              ? Colors.white
              : '#3E2723'.toColor(),
          padding: AppPaddings.symmetric(v: 16, h: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
            side: isPrimary
                ? BorderSide.none
                : BorderSide(
                    color: Colors.grey.withOpacity(0.3),
                    width: 1,
                  ),
          ),
          elevation: isPrimary ? 4 : 0,
        ),
      ),
    );
  }

  Widget _buildPhotoGuidelinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AutoTranslateText(
          'Photo Guidelines',
          style: MyTextTheme.mediumBCB.copyWith(
            color: '#3E2723'.toColor(),
            fontWeight: FontWeight.bold,
          ),
        ),
        
        Spacing.h(16),
        
        _buildGuidelineCard(
          icon: Icons.lightbulb_outline,
          text: 'Use a well-lit background',
        ),
        
        Spacing.h(12),
        
        _buildGuidelineCard(
          icon: Icons.pan_tool,
          text: 'Keep palm fully inside frame',
        ),
        
        Spacing.h(12),
        
        _buildGuidelineCard(
          icon: Icons.wb_sunny_outlined,
          text: 'Avoid shadows on the hand',
        ),
      ],
    );
  }

  Widget _buildGuidelineCard({
    required IconData icon,
    required String text,
  }) {
    return Container(
      padding: AppPaddings.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: "#F38B3B".toColor(),
            size: 24.w,
          ),
          Spacing.w(12),
          Expanded(
            child: AutoTranslateText(
              text,
              style: MyTextTheme.mediumBCN.copyWith(
                color: '#3E2723'.toColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContinueButton(BuildContext context, PalmReadingController controller) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: controller.selectedPalmImage.value != null
            ? () => controller.onContinueFromUpload()
            : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: controller.selectedPalmImage.value != null
              ? "#F38B3B".toColor()
              : "#F38B3B".toColor().withOpacity(0.5),
          foregroundColor: Colors.white,
          padding: AppPaddings.symmetric(v: 16, h: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 4,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AutoTranslateText(
              'Continue',
              style: MyTextTheme.mediumBCB.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Spacing.w(8),
            Icon(
              Icons.arrow_forward,
              color: Colors.white,
              size: 20.w,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPalmAnalysisSection(PalmReadingController controller) {
    return Obx(() {
      final isLeftHand = controller.selectedHand.value == 'Left';
      
      return Container(
        padding: AppPaddings.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            // Accuracy message
            AutoTranslateText(
              'We read your destiny with 95% accuracy!',
              style: MyTextTheme.mediumBCB.copyWith(
                color: "#F38B3B".toColor(),
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            
            Spacing.h(24),
            
            // Hand diagram
            Container(
              width: double.infinity,
              height: 300.h,
              decoration: BoxDecoration(
                color: controller.selectedPalmImage.value != null 
                    ? Colors.transparent 
                    : const Color(0xFFF5F5F5),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Palm image background
                  if (controller.selectedPalmImage.value != null)
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: Image.file(
                        controller.selectedPalmImage.value!,
                        width: double.infinity,
                        height: 300.h,
                        fit: BoxFit.cover,
                      ),
                    ),
                  
                  // Semi-transparent overlay to make lines more visible
                  if (controller.selectedPalmImage.value != null)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                  
                  // Hand outline
                  CustomPaint(
                    size: Size(250.w, 300.h),
                    painter: HandDiagramPainter(isLeftHand: isLeftHand),
                  ),
                  
                  // Planetary labels
                  _buildPlanetaryLabels(isLeftHand),
                ],
              ),
            ),
            
            Spacing.h(24),
            
            // Palm lines buttons
            _buildPalmLinesButtons(),
          ],
        ),
      );
    });
  }

  Widget _buildPlanetaryLabels(bool isLeftHand) {
    return Positioned.fill(
      child: Stack(
        children: [
          // Jupiter (Index finger)
          Positioned(
            top: 30.h,
            left: isLeftHand ? 60.w : 100.w,
            child: _buildPlanetLabel('Jupiter', '♃'),
          ),
          // Saturn (Middle finger)
          Positioned(
            top: 30.h,
            left: isLeftHand ? 110.w : 130.w,
            child: _buildPlanetLabel('Saturn', '♄'),
          ),
          // Sun (Ring finger)
          Positioned(
            top: 30.h,
            left: isLeftHand ? 160.w : 160.w,
            child: _buildPlanetLabel('Sun', '☉'),
          ),
          // Mercury (Pinky)
          Positioned(
            top: 30.h,
            left: isLeftHand ? 210.w : 190.w,
            child: _buildPlanetLabel('Mercury', '☿'),
          ),
          // Venus (Thumb base)
          Positioned(
            top: 150.h,
            left: isLeftHand ? 10.w : 240.w,
            child: _buildPlanetLabel('Venus', '♀'),
          ),
          // Moon (Lower palm)
          Positioned(
            top: 240.h,
            left: isLeftHand ? 110.w : 130.w,
            child: _buildPlanetLabel('Moon', '☾'),
          ),
        ],
      ),
    );
  }

  Widget _buildPlanetLabel(String name, String symbol) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AutoTranslateText(
          symbol,
          style: TextStyle(
            color: '#EA632B'.toColor(),
          ),
        ),
        Spacing.h(4),
        AutoTranslateText(
          name,
          style: MyTextTheme.smallBCN.copyWith(
            color: '#3E2723'.toColor(),
          ).merge(AppTypography.label),
        ),
      ],
    );
  }

  Widget _buildPalmLinesButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildLineButton('Life line', Colors.lightBlue),
            ),
            Spacing.w(12),
            Expanded(
              child: _buildLineButton('Head line', Colors.orange),
            ),
          ],
        ),
        Spacing.h(12),
        Row(
          children: [
            Expanded(
              child: _buildLineButton('Fate line', Colors.purple),
            ),
            Spacing.w(12),
            Expanded(
              child: _buildLineButton('Heart line', Colors.red),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLineButton(String label, Color color) {
    return Container(
      padding: AppPaddings.symmetric(v: 12, h: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: AutoTranslateText(
        label,
        style: MyTextTheme.mediumBCB.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

// Custom painter for hand diagram
class HandDiagramPainter extends CustomPainter {
  final bool isLeftHand;

  HandDiagramPainter({required this.isLeftHand});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = "#F38B3B".toColor()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    // Draw a simplified hand outline
    final path = Path();
    
    // Palm base
    path.moveTo(size.width * 0.3, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 0.8,
      size.width * 0.7,
      size.height * 0.7,
    );
    
    // Thumb
    path.moveTo(size.width * 0.3, size.height * 0.7);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.15,
      size.height * 0.3,
    );
    
    // Fingers
    for (int i = 0; i < 4; i++) {
      final fingerX = size.width * (0.4 + i * 0.15);
      path.moveTo(fingerX, size.height * 0.2);
      path.lineTo(fingerX, size.height * 0.05);
    }
    
    // Draw palm lines
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    
    // Life line (curved around thumb)
    linePaint.color = Colors.lightBlue;
    final lifeLine = Path();
    lifeLine.moveTo(size.width * 0.25, size.height * 0.3);
    lifeLine.quadraticBezierTo(
      size.width * 0.2,
      size.height * 0.5,
      size.width * 0.3,
      size.height * 0.7,
    );
    canvas.drawPath(lifeLine, linePaint);
    
    // Head line (horizontal middle)
    linePaint.color = Colors.orange;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.4),
      Offset(size.width * 0.8, size.height * 0.4),
      linePaint,
    );
    
    // Heart line (top horizontal)
    linePaint.color = Colors.red;
    canvas.drawLine(
      Offset(size.width * 0.2, size.height * 0.25),
      Offset(size.width * 0.8, size.height * 0.25),
      linePaint,
    );
    
    // Fate line (vertical center)
    linePaint.color = Colors.purple;
    canvas.drawLine(
      Offset(size.width * 0.5, size.height * 0.2),
      Offset(size.width * 0.5, size.height * 0.7),
      linePaint,
    );
    
    // Draw hand outline
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

