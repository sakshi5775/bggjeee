import 'package:astrobharataiuser/screens/user_dashboard/controller/all_videos_controller.dart';
import 'package:get/get.dart';

class AllVideosBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AllVideosController());
  }
}
