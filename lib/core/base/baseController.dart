import 'package:get/get.dart';
import 'api_helper_mixin.dart';
import 'navigation_service.dart';

abstract class BaseController extends GetxController
    with NavigationService, ApiHelperMixin {}

abstract class BasePage<T extends BaseController> extends GetView<T> {
  const BasePage({super.key});
}
