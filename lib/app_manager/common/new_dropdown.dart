//
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import '../../core/value/dimension.dart';
// import '../utils/app_color.dart';
// import '../utils/constant.dart';
// import 'my_text_theme.dart';
//
// class AnimatedDropdown extends StatefulWidget {
//   final List<dynamic> items;
//   final void Function(int index, Map<String, dynamic> selectedItem) onChanged;
//   final String hint;
//   final String valFrom;
//   final Key? resetKey;
//   final String? keyValue;
//   final String Function(Map<String, dynamic> item)? customDisplay;
//
//   const AnimatedDropdown({
//     super.key,
//     required this.items,
//     required this.onChanged,
//     this.hint = "Select an item",
//     required this.valFrom,
//     this.resetKey,
//     this.keyValue,
//     this.customDisplay,
//   });
//
//   @override
//   State<AnimatedDropdown> createState() => _AnimatedDropdownState();
// }
//
// class _AnimatedDropdownState extends State<AnimatedDropdown> {
//   Map<String, dynamic>? _selectedItem;
//
//   @override
//   void initState() {
//     super.initState();
//
//     if (widget.items.isNotEmpty && widget.valFrom.isNotEmpty) {
//       final matchedItem = widget.items.firstWhere(
//             (item) => item[widget.valFrom] == widget.keyValue,
//         orElse: () => <String, String>{},
//       );
//
//       if (matchedItem.isNotEmpty) {
//         _selectedItem = matchedItem;
//       }
//     }
//   }
//
//
//   @override
//   void didUpdateWidget(covariant AnimatedDropdown oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (widget.resetKey != oldWidget.resetKey) {
//       setState(() {
//         _selectedItem = null;
//       });
//     }
//   }
//
//   void _showBottomSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: Colors.transparent,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (BuildContext context) {
//         return StatefulBuilder(
//           builder: (context, StateSetter state) {
//             return DraggableScrollableSheet(
//               initialChildSize: 0.50,
//               maxChildSize: 0.5,
//               minChildSize: 0.2,
//               builder: (context, scrollController) {
//                 return Container(
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//                   ),
//                   padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Center(
//                         child: Container(
//                           width: 40,
//                           height: 5,
//                           decoration: BoxDecoration(
//                             color: Colors.grey[400],
//                             borderRadius: BorderRadius.circular(20),
//                           ),
//                         ),
//                       ),
//                       SizedBox(height: 20),
//                       AutoTranslateText(
//                         widget.hint,
//                         style: MyTextTheme.largeBCB,
//                         textAlign: TextAlign.center,
//                       ),
//                       Spacing.h(15),
//                       widget.items.isNotEmpty
//                           ? Expanded(
//                         child: ListView.builder(
//                           controller: scrollController,
//                           physics: BouncingScrollPhysics(),
//                           padding: const EdgeInsets.symmetric(vertical: 16),
//                           itemCount: widget.items.length,
//                           itemBuilder: (context, index) {
//                             final item = widget.items[index];
//                             final value = widget.customDisplay != null
//                                 ? widget.customDisplay!(item)
//                                 : item[widget.valFrom];
//
//                             return GestureDetector(
//                               onTap: () {
//                                 setState(() {
//                                   _selectedItem = item;
//                                 });
//
//                                 widget.onChanged(
//                                   widget.items.indexOf(item),
//                                   item,
//                                 );
//
//                                 Navigator.of(context).pop();
//                               },
//                               child: Padding(
//                                 padding: AppPaddings.only(
//                                   bottom: 15
//                                 ),
//                                 child: Container(
//                                   decoration: BoxDecoration(
//                                     borderRadius: AppRadius.all(20),
//                                     color: AppColor.primary.withAlpha(20),
//                                   ),
//                                   child: Padding(
//                                     padding: AppPaddings.all(12),
//                                     child: AutoTranslateText(
//                                       value.toString(),
//                                       style: MyTextTheme.largeBCB,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                         ),
//                       )
//                           : Center(
//                         child: Column(
//                           children: [
//                             Image.asset(
//                               Constant.noDataFoundImage,
//                               height: 150.h,
//                             ),
//                             AutoTranslateText(
//                               'No Data Found...',
//                               style: MyTextTheme.largeBCB,
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               },
//             );
//           },
//         );
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     String? displayValue = _selectedItem != null
//         ? (widget.customDisplay != null
//         ? widget.customDisplay!(_selectedItem!)
//         : _selectedItem![widget.valFrom])
//         : null;
//
//     return GestureDetector(
//       onTap: () => _showBottomSheet(context),
//       child: Container(
//         padding: AppPaddings.symmetric(h: 12 , v: 12),
//         decoration: BoxDecoration(
//           color: AppColor.primary,
//           borderRadius: AppRadius.all(20),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             AutoTranslateText(
//               displayValue ?? widget.hint,
//               style: TextStyle(
//                 fontSize: 14.sp,
//                 color: displayValue != null ? Colors.black : Colors.grey,
//               ),
//             ),
//             Icon(Icons.keyboard_arrow_down ),
//           ],
//         ),
//       ),
//     );
//   }
// }
