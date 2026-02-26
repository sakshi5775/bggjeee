import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/user_main_controller.dart';
import 'package:astrobharataiuser/core/base/baseController.dart';
import 'package:astrobharataiuser/core/routes/app_routes.dart';

class MeaningController extends BaseController {
  void navigateToPlayer() {
    UserMainController.pushInCurrentTab(AppRoutes.devotionalPlayer);
  }
}
