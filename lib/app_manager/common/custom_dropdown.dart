import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
 
class CustomDropdown<T> extends StatelessWidget {
  final String label;
  final Color? labelColor;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final Function(T?) onChanged;
  final String? Function(T?)? validator;
  final bool isRequired;
  final String? hintText;
  final IconData? prefixIcon;
  final String Function(T?)? displayText;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    this.validator,
    this.labelColor,
    this.isRequired = false,
    this.hintText,
    this.prefixIcon,
    this.displayText,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: onChanged,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText ?? label,
        hintStyle: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary),
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon, color: AppColors.saffron, size: 20)
            : null,
        suffixIcon: Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.saffron,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.saffron, width: 1.5),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.saffron, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Colors.red, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColors.warning, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        filled: true,
        fillColor: Colors.white,
      ),
      icon: const SizedBox.shrink(),
      dropdownColor: Colors.white,
      isExpanded: true,
      style: MyTextTheme.smallBCN,
      selectedItemBuilder: (context) {
        return items.map((item) {
          return Container(
            alignment: Alignment.centerLeft,
            child: AutoTranslateText(
              displayText != null
                  ? displayText!(item.value)
                  : item.value.toString(),
              style: MyTextTheme.mediumBCB.copyWith(
                color: AppColors.saffron,
              ),
            ),
          );
        }).toList();
      },
    );
  }
}
