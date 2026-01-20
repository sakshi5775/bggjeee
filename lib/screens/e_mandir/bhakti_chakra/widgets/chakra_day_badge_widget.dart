import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/screens/e_mandir/bhakti_chakra/widgets/chakra_status_enum.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class ChakraDayBadgeWidget extends StatelessWidget {
  final String day;
  final ChakraStatus status;

  const ChakraDayBadgeWidget({
    super.key,
    required this.day,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      width: 28,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: status == ChakraStatus.locked
            ? Colors.grey.shade300
            : Colors.deepOrange,
      ),
      alignment: Alignment.center,
      child: AutoTranslateText(
        day,
        style: MyTextTheme.smallBCN.copyWith(
          color: status == ChakraStatus.locked
              ? Colors.grey
              : Colors.white,
          fontWeight: FontWeight.bold,
        ),
        translate: false,
      ),
    );
  }
}
