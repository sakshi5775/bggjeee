import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../core/value/dimension.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';

// ignore: must_be_immutable
class MyTextField extends StatefulWidget {
  final String? hintText;
  final String? labelText;
  final String? headerText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final int? maxLine;
  final int? minLine;
  final int? maxLength;
  final bool? isPasswordField;
  final bool? enabled;
  final bool? readOnly;
  final TextAlign? textAlign;
  final TextInputType? keyboardType;
  final ValueChanged? onChanged;
  final Color? borderColor;
  List<TextInputFormatter>? inputFormatters;
  final BorderRadius? borderRadius;
  final bool? filled;
  final Color? filledColor;
  final TextStyle? headerTextStyle;
  final void Function()? onTap;
  MyTextField({
    super.key,
    this.hintText,
    this.controller,
    this.isPasswordField,
    this.validator,
    this.prefixIcon,
    this.labelText,
    this.suffixIcon,
    this.maxLength,
    this.enabled,
    this.readOnly,
    this.textAlign,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
    this.borderColor,
    this.borderRadius,
    this.maxLine,
    this.minLine,
    this.filled,
    this.filledColor,
    this.headerText,
    this.onTap,
    this.headerTextStyle,
  });

  @override
  _MyTextFieldState createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool obscure = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.isPasswordField ?? false) {
      obscure = widget.isPasswordField!;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.headerText != null
            ? AutoTranslateText(
                widget.headerText ?? '',
                style:
                    widget.headerTextStyle ??
                    MyTextTheme.mediumBCB.copyWith(color: AppColors.saffron),
              )
            : Container(),
        Spacing.h(8),
        TextFormField(
          enabled: widget.enabled,
          readOnly: widget.readOnly ?? false,
          onTap: widget.onTap,
          onChanged: widget.onChanged,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          controller: widget.controller,
          onTapOutside: (val) {
            FocusScope.of(context).unfocus();
          },
          onSaved: (emal) {
            // Email
          },
          style: MyTextTheme.mediumBCB.copyWith(color: AppColors.textPrimary),

          validator: widget.validator,
          inputFormatters: widget.inputFormatters,
          maxLines: widget.isPasswordField == true ? 1 : widget.maxLine,
          obscureText: widget.isPasswordField == null ? false : obscure,
          textInputAction: TextInputAction.next,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            labelText: widget.labelText,
            hintText: widget.hintText,
            prefixIcon: widget.prefixIcon,
            suffixIcon:
                (widget.isPasswordField == null ||
                    widget.isPasswordField == false)
                ? widget.suffixIcon
                : IconButton(
                    splashRadius: 5,
                    icon: obscure
                        ? Icon(Icons.visibility, color: AppColors.textSecondary)
                        : Icon(
                            Icons.visibility_off,
                            color: AppColors.textSecondary,
                          ),
                    onPressed: () {
                      setState(() {
                        obscure = !obscure;
                      });
                    },
                  ),
          ),
        ),
      ],
    );
  }
}
