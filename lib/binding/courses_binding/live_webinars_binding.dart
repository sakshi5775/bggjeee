import 'package:get/get.dart';
import 'package:astrobharataiuser/screens/courses/controllers/live_webinars_controller.dart';
import 'package:astrobharataiuser/screens/courses/services/courses_service.dart';
import 'package:astrobharataiuser/screens/courses/services/webinar_service.dart';

class LiveWebinarsBinding extends Bindings {
  @override
  void dependencies() {
    // Register Services first
    Get.lazyPut<CoursesService>(() => CoursesService());
    Get.lazyPut<WebinarService>(() => WebinarService());

    // Then register Controller
    Get.lazyPut<LiveWebinarsController>(() => LiveWebinarsController());
  }
}
