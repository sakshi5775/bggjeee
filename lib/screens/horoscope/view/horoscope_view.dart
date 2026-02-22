// import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
// import 'package:astrobharataiuser/core/value/dimension.dart';
// import 'package:astrobharataiuser/screens/astrology_services/widgets/astrology_header_widget.dart';
// import 'package:astrobharataiuser/screens/horoscope/controller/horoscope_controller.dart';
// import 'package:astrobharataiuser/theme/app_typography.dart';
// import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

// class HoroscopeView extends StatelessWidget {
//   const HoroscopeView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final controller = Get.put(HoroscopeController());
    
//     return Scaffold(
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topRight,
//             end: Alignment.bottomLeft,
//             colors: [
//               const Color(0xFFF7C443), // #F7C443 - Golden yellow
//               const Color(0xFFFFFCF3), // #FFFCF3 - Light cream
//               const Color(0xFFFFFFFF), // #FFFFFF - White
//             ],
//             stops: const [0.0, 0.4671, 1.0],
//           ),
//         ),
//         child: SafeArea(
//           child: Column(
//             children: [
//               // Header with back button, title, and zodiac selector
//               _buildHeader(context, controller),
              
//               // Main Content
//               Expanded(
//                 child: SingleChildScrollView(
//                   child: Column(
//                     children: [
//                       // Navigation Tabs
//                       _buildTabs(controller),
//                       Spacing.h(16),
                      
//                       // Horoscope Content Card
//                       _buildHoroscopeCard(controller),
//                       Spacing.h(16),
                      
//                       // Today's Panchang Card
//                       _buildPanchangCard(controller),
//                       Spacing.h(24),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader(BuildContext context, HoroscopeController controller) {
//     return AstrologyHeaderWidget(
//       padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//       content: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Back button and Title
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               GestureDetector(
//                 onTap: () => Get.back(),
//                 child: Row(
//                   children: [
//                     Icon(
//                       Icons.arrow_back,
//                       color: const Color(0xFFFEF6C3), // Light yellow
//                       size: 24.w,
//                     ),
//                     Spacing.w(8),
//                     AutoTranslateText(
//                       'Horoscope',
//                       style: MyTextTheme.mediumBCB.copyWith(
//                         color: const Color(0xFFFEF6C3), // Light yellow
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//           Spacing.h(16),
//           // Zodiac Sign Selector
//           Obx(() => GestureDetector(
//             onTap: () => _showZodiacSignPicker(context, controller),
//             child: Container(
//               padding: AppPaddings.symmetric(h: 16, v: 12),
//               decoration: BoxDecoration(
//                 color: const Color(0xFFfff7c9), // Light yellow
//                 borderRadius: BorderRadius.circular(12.r),
//               ),
//               child: Row(
//                 children: [
//                   AutoTranslateText(
//                     '👑',
//                     style: AppTypography.h2,
//                   ),
//                   Spacing.w(12),
//                   Expanded(
//                     child: Row(
//                       children: [
//                         AutoTranslateText(
//                           controller.selectedZodiacSign.value,
//                           style: MyTextTheme.mediumBCB.copyWith(
//                             color: const Color(0xFF5F2221),
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         Spacing.w(8),
//                         AutoTranslateText(
//                           controller.getZodiacSymbol(controller.selectedZodiacSign.value),
//                           style: TextStyle(
//                             color: const Color(0xFF5F2221),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   Icon(
//                     Icons.keyboard_arrow_down,
//                     color: const Color(0xFF5F2221),
//                     size: 24.w,
//                   ),
//                 ],
//               ),
//             ),
//           )),
//           Spacing.h(16),
//         ],
//       ),
//     );
//   }

//   Widget _buildTabs(HoroscopeController controller) {
//     return Padding(
//       padding: AppPaddings.symmetric(h: 16),
//       child: Container(
//         padding: EdgeInsets.all(4.w),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFFFCF3), // Light cream background for the container
//           borderRadius: BorderRadius.circular(12.r),
//         ),
//         child: Row(
//           children: controller.tabs.asMap().entries.map((entry) {
//             final index = entry.key;
//             final tab = entry.value;
//             final isSelected = controller.selectedTab.value == tab;
//             return Expanded(
//               child: Padding(
//                 padding: EdgeInsets.only(
//                   right: index < controller.tabs.length - 1 ? 4.w : 0,
//                 ),
//                 child: GestureDetector(
//                   onTap: () => controller.setSelectedTab(tab),
//                   child: Container(
//                     padding: AppPaddings.symmetric(v: 12, h: 8),
//                     decoration: BoxDecoration(
//                       color: isSelected 
//                           ? const Color(0xFFDFB343) // Golden yellow when selected
//                           : Colors.transparent, // Transparent when not selected
//                       borderRadius: BorderRadius.circular(8.r),
//                     ),
//                     child: AutoTranslateText(
//                       tab,
//                       textAlign: TextAlign.center,
//                       style: MyTextTheme.mediumBCN.copyWith(
//                         color: isSelected 
//                             ? Colors.white // White text when selected
//                             : const Color(0xFF5F2221).withValues(alpha: 0.7), // Dark text when not selected
//                         fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ),
//     );
//   }

//   Widget _buildHoroscopeCard(HoroscopeController controller) {
//     return Padding(
//       padding: AppPaddings.symmetric(h: 16),
//       child: Container(
//         padding: AppPaddings.all(20),
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(16.r),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withValues(alpha: 0.05),
//               blurRadius: 10,
//               offset: const Offset(0, 4),
//             ),
//           ],
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Date and Share Icon
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 AutoTranslateText(
//                   'Today - ${controller.getCurrentDate()}',
//                   style: MyTextTheme.mediumBCN.copyWith(
//                     color: const Color(0xFFFF6B35), // Light orange
//                     fontWeight: FontWeight.w500,
//                   ),
//                 ),
//                 IconButton(
//                   onPressed: () {
//                     // Handle share
//                   },
//                   icon: Icon(
//                     Icons.share,
//                     color: const Color(0xFF5F2221),
//                     size: 20.w,
//                   ),
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                 ),
//               ],
//             ),
//             Spacing.h(16),
//             // Horoscope AutoTranslateText
//             Obx(() => AutoTranslateText(
//               controller.horoscopeText.value,
//               style: MyTextTheme.mediumBCN.copyWith(
//                 color: const Color(0xFF5F2221),
//                 height: 1.6,
//               ),
//             )),
//             Spacing.h(20),
//             // Key Details Grid
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDetailCard('Lucky Color', controller.luckyColor.value),
//                 ),
//                 Spacing.w(12),
//                 Expanded(
//                   child: _buildDetailCard('Lucky Number', controller.luckyNumber.value),
//                 ),
//               ],
//             ),
//             Spacing.h(12),
//             Row(
//               children: [
//                 Expanded(
//                   child: _buildDetailCard('Mood', controller.mood.value),
//                 ),
//                 Spacing.w(12),
//                 Expanded(
//                   child: _buildDetailCard('Best Match', controller.bestMatch.value),
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailCard(String label, String value) {
//     return Container(
//       padding: AppPaddings.all(12),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           begin: Alignment.topCenter,
//           end: Alignment.bottomCenter,
//           colors: [
//             const Color(0xFFFFFCF3), // Light cream at top
//             const Color(0xFFFFFFFF), // White at bottom
//           ],
//         ),
//         borderRadius: BorderRadius.circular(12.r),
//         border: Border.all(
//           color: const Color(0xFFE0E0E0).withValues(alpha: 0.3),
//           width: 1,
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           AutoTranslateText(
//             label,
//             style: MyTextTheme.smallBCN.copyWith(
//               color: const Color(0xFF666666),
//             ).merge(AppTypography.label),
//           ),
//           Spacing.h(4),
//           AutoTranslateText(
//             value,
//             style: MyTextTheme.mediumBCB.copyWith(
//               color: const Color(0xFFDFB343), // Golden yellow for values
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPanchangCard(HoroscopeController controller) {
//     return Padding(
//       padding: AppPaddings.symmetric(h: 16),
//       child: Container(
//         padding: AppPaddings.all(20),
//         decoration: BoxDecoration(
//           color: const Color(0xFF5F2221), // Dark reddish-brown
//           borderRadius: BorderRadius.circular(16.r),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Title with Calendar Icon
//             Row(
//               children: [
//                 Icon(
//                   Icons.calendar_today,
//                   color: const Color(0xFFFEF6C3),
//                   size: 20.w,
//                 ),
//                 Spacing.w(8),
//                 AutoTranslateText(
//                   'Today\'s Panchang',
//                   style: MyTextTheme.mediumBCB.copyWith(
//                     color: const Color(0xFFFEF6C3),
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//               ],
//             ),
//             Spacing.h(16),
//             // Panchang Details
//             Obx(() => Row(
//               children: [
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildPanchangItem('Tithi', controller.tithi.value),
//                       Spacing.h(12),
//                       _buildPanchangItem('Nakshatra', controller.nakshatra.value),
//                     ],
//                   ),
//                 ),
//                 Spacing.w(16),
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       _buildPanchangItem('Yoga', controller.yoga.value),
//                       Spacing.h(12),
//                       _buildPanchangItem('Karana', controller.karana.value),
//                     ],
//                   ),
//                 ),
//               ],
//             )),
//             Spacing.h(16),
//             Divider(
//               color: const Color(0xFFFEF6C3).withValues(alpha: 0.3),
//               thickness: 1,
//             ),
//             Spacing.h(12),
//             // Shubh Muhurat
//             AutoTranslateText(
//               'Shubh Muhurat',
//               style: MyTextTheme.mediumBCB.copyWith(
//                 color: const Color(0xFFFEF6C3),
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Spacing.h(8),
//             Obx(() => Column(
//               children: controller.shubhMuhurat.map((time) {
//                 return Padding(
//                   padding: EdgeInsets.only(bottom: 4.h),
//                   child: AutoTranslateText(
//                     time,
//                     style: MyTextTheme.mediumBCN.copyWith(
//                       color: const Color(0xFFFEF6C3).withValues(alpha: 0.9),
//                     ).merge(AppTypography.body1),
//                   ),
//                 );
//               }).toList(),
//             )),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPanchangItem(String label, String value) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         AutoTranslateText(
//           label,
//           style: MyTextTheme.smallBCN.copyWith(
//             color: const Color(0xFFFEF6C3).withValues(alpha: 0.7),
//           ),
//         ),
//         Spacing.h(4),
//         AutoTranslateText(
//           value,
//           style: MyTextTheme.mediumBCN.copyWith(
//             color: const Color(0xFFFEF6C3),
//             fontWeight: FontWeight.w500,
//           ).merge(AppTypography.body1),
//         ),
//       ],
//     );
//   }

//   void _showZodiacSignPicker(BuildContext context, HoroscopeController controller) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.transparent,
//       builder: (context) => Container(
//         decoration: BoxDecoration(
//           color: Color(0xFFfff7c9),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(20.r),
//             topRight: Radius.circular(20.r),
//           ),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Container(
//               margin: EdgeInsets.only(top: 12.h, bottom: 8.h),
//               width: 40.w,
//               height: 4.h,
//               decoration: BoxDecoration(
//                 color: Colors.grey[300],
//                 borderRadius: BorderRadius.circular(2.r),
//               ),
//             ),
//             Padding(
//               padding: AppPaddings.symmetric(h: 16, v: 12),
//               child: AutoTranslateText(
//                 'Select Zodiac Sign',
//                 style: MyTextTheme.mediumBCB.copyWith(
//                   color: const Color(0xFF5F2221),
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ),
//             Flexible(
//               child: ConstrainedBox(
//                 constraints: BoxConstraints(
//                   maxHeight: MediaQuery.of(context).size.height * 0.5,
//                 ),
//                 child: ListView.builder(
//                   shrinkWrap: true,
//                   physics: const AlwaysScrollableScrollPhysics(),
//                   itemCount: controller.zodiacSigns.length,
//                   itemBuilder: (context, index) {
//                     final sign = controller.zodiacSigns[index];
//                     final isSelected = controller.selectedZodiacSign.value == sign;
//                     return ListTile(
//                       leading: AutoTranslateText(
//                         controller.getZodiacSymbol(sign),
//                         style: AppTypography.h2,
//                       ),
//                       title: AutoTranslateText(
//                         sign,
//                         style: MyTextTheme.mediumBCN.copyWith(
//                           color: const Color(0xFF5F2221),
//                           fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                         ),
//                       ),
//                       trailing: isSelected
//                           ? Icon(
//                               Icons.check,
//                               color: const Color(0xFFDFB343),
//                               size: 24.w,
//                             )
//                           : null,
//                       onTap: () {
//                         controller.setSelectedZodiacSign(sign);
//                         Navigator.pop(context);
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//             Spacing.h(16),
//           ],
//         ),
//       ),
//     );
//   }
// }


