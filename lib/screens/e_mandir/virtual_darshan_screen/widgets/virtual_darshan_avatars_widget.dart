import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/core/value/dimension.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
import 'package:flutter/material.dart';

class VirtualDarshanAvatarsWidget extends StatelessWidget {
  const VirtualDarshanAvatarsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 60,
      left: 12,
      right: 12,
      child: SizedBox(
        height: 50,
        child: Row(
          children: [
            Container(
              padding: AppPaddings.all(2),
              decoration: BoxDecoration(
                borderRadius: AppRadius.all(30),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 25,
                    backgroundImage: AssetImage(AppConstant.eMandirGanesha),
                  ),
                  Padding(
                    padding: AppPaddings.all(4),
                    child: AutoTranslateText(
                      "Shri Ganesh",
                      style: MyTextTheme.mediumBCN.copyWith(
                        color: Colors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Spacing.w(10),
            Expanded(
              child: ListView.builder(
                itemCount: 15,
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, index) {
                  return Container(
                    margin: AppMargin.only(right: 6),
                    padding: AppPaddings.all(2),
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [Colors.orange, Colors.deepOrange],
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 30,
                      backgroundImage: AssetImage(AppConstant.eMandirGodIcon),
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
