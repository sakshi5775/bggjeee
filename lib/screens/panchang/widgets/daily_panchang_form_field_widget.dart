import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app_manager/my_text_field.dart';

class DailyPanchangFormFieldWidget extends StatelessWidget {
  final String label;
  final String? hintText;
  final TextEditingController? controller;
  final IconData? suffixIcon;
  final bool readOnly;
  final VoidCallback? onTap;
  final TextInputType? keyboardType;

  const DailyPanchangFormFieldWidget({
    super.key,
    required this.label,
    this.hintText,
    this.controller,
    this.suffixIcon,
    this.readOnly = false,
    this.onTap,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppPaddings.all(16),
      decoration: BoxDecoration(
        color: "#FFFFFF".toColor(),
        borderRadius: BorderRadius.circular(14.04.r),
      ),
      child: MyTextField(
        headerText: label,
        controller: controller,
        readOnly: readOnly,
        onTap: onTap,
        keyboardType: keyboardType,
        hintText: hintText,
        suffixIcon: suffixIcon != null
            ? Icon(suffixIcon, size: 20.05.h, color: "#646464".toColor())
            : null,
      ),
    );
  }
}
