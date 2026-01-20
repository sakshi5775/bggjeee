import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan_screen/controller/virtual_darshan_controller.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan_screen/widgets/virtual_darshan_action_buttons_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan_screen/widgets/virtual_darshan_avatars_widget.dart';
import 'package:astrobharataiuser/screens/e_mandir/virtual_darshan_screen/widgets/virtual_darshan_header_widget.dart';
import 'package:astrobharataiuser/utils/app_constant.dart';
import 'package:flutter/material.dart';

class VirtualDarshanView extends BasePage<VirtualDarshanController> {
  const VirtualDarshanView({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: const DecorationImage(
              image: AssetImage(AppConstant.eMandirGanesha),
              fit: BoxFit.cover,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.25),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Stack(
            children: [
              const VirtualDarshanHeaderWidget(),
              const VirtualDarshanAvatarsWidget(),
              const VirtualDarshanActionButtonsWidget(),
            ],
          ),
        ),
      ),
    );
  }
}
