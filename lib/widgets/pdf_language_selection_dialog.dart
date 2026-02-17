import 'package:astrobharataiuser/app_manager/ext/hex_color_ext.dart';
import 'package:astrobharataiuser/core/models/app_language_model.dart';
import 'package:astrobharataiuser/theme/app_typography.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PdfLanguageSelectionDialog extends StatefulWidget {
  final Function(AppLanguageModel) onLanguageSelected;

  const PdfLanguageSelectionDialog({Key? key, required this.onLanguageSelected})
    : super(key: key);

  @override
  State<PdfLanguageSelectionDialog> createState() =>
      _PdfLanguageSelectionDialogState();
}

class _PdfLanguageSelectionDialogState
    extends State<PdfLanguageSelectionDialog> {
  List<AppLanguageModel> _languages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLanguages();
  }

  Future<void> _loadLanguages() async {
    final langs = await LanguageModelService.getLanguages();
    if (mounted) {
      setState(() {
        _languages = langs;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 20.h, horizontal: 16.w),
        constraints: BoxConstraints(maxHeight: 500.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AutoTranslateText(
              "Select Report Language",
              style: AppTypography.h2.copyWith(color: "#6F221E".toColor()),
            ),
            SizedBox(height: 8.h),
            AutoTranslateText(
              "The report will be translated into your selected language.",
              style: AppTypography.body2.copyWith(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            Divider(height: 32.h),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (context, index) =>
                      Divider(height: 1, color: Colors.grey.withOpacity(0.1)),
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    return ListTile(
                      onTap: () {
                        Navigator.pop(context);
                        widget.onLanguageSelected(lang);
                      },
                      leading: Container(
                        width: 36.w,
                        height: 36.w,
                        decoration: BoxDecoration(
                          color: "#6F221E".toColor().withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            lang.code.toUpperCase(),
                            style: AppTypography.label.copyWith(
                              color: "#6F221E".toColor(),
                              fontWeight: FontWeight.bold,
                              fontSize: 10.sp,
                            ),
                          ),
                        ),
                      ),
                      title: Text(
                        lang.nameEn,
                        style: AppTypography.body1.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        lang.nameNative,
                        style: AppTypography.body2.copyWith(color: Colors.grey),
                      ),
                      trailing: Icon(
                        Icons.translate,
                        size: 18.w,
                        color: "#6F221E".toColor().withOpacity(0.5),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
