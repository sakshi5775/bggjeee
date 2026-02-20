import 'package:astrobharataiuser/screens/support/controller/support_ticket_controller.dart';
import 'package:get/get.dart';

class SupportTicketBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SupportTicketController>(() => SupportTicketController());
  }
}

