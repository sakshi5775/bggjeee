
import 'package:astrobharataiuser/app_manager/my_text_theme.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';
import 'package:astrobharataiuser/widgets/auto_translate_text.dart';
 

class NoDataFoundWidget extends StatelessWidget {
  const NoDataFoundWidget({super.key, required void Function() onPress});

  @override
  Widget build(BuildContext context) {
    return    Column(
      children: [

        Image.asset(AppConstant.noDataFoundImage ,
        ),
        AutoTranslateText('No Data Found...' ,
          style: MyTextTheme.largeBCB,),
      ],
    );
  }
}
