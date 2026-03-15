import 'package:get/get.dart';
import 'package:astrobharataiuser/controllers/global_chat_controller.dart';
import 'package:astrobharataiuser/core/services/chat_minimize_manager.dart';
import 'package:astrobharataiuser/services/global_free_service_manager.dart';
import 'package:astrobharataiuser/core/services/notification_service.dart';
import 'package:astrobharataiuser/screens/user_dashboard/controller/ai_pricing_controller.dart';
import 'package:astrobharataiuser/apihelper/network_service/network_service.dart';
import '../api_provider/api_provider.dart';
import '../repositories/apirepository.dart';
import 'package:astrobharataiuser/core/services/auth_service.dart';

Future<void> init() async {
  Get.put(NetworkService(), permanent: true);
  Get.lazyPut(() => ApiClient(appBaseUrl: "http://3.109.91.254:8000/api/"));
  Get.lazyPut(
    () => ApiClient(appBaseUrl: "http://3.109.91.254:8009/api/"),
    tag: 'chat',
  );

  Get.lazyPut(() => ApiRepository(apiClient: Get.find()), fenix: true);
  Get.lazyPut(
    () => ApiRepository(apiClient: Get.find(tag: 'chat')),
    tag: 'chat',
    fenix: true,
  );
  Get.lazyPut(() => AuthService(), fenix: true);

  // Register global free service manager (will be started after login and dashboard load)
  Get.put(GlobalFreeServiceManager(), permanent: true);
  Get.put(GlobalChatController(), permanent: true);
  Get.put(AiPricingController(), permanent: true);
  Get.put(ChatMinimizeManager(), permanent: true);

  // Register notification service (permanent across app lifecycle)
  // ⚠️ CRITICAL: Wrap in try-catch to prevent app crash if notification init fails
  try {
    await Get.putAsync(() => NotificationService().init(), permanent: true);
    print('[Dependencies] ✅ NotificationService initialized successfully');
  } catch (e, stackTrace) {
    print('[Dependencies] ❌ NotificationService init error: $e');
    print('[Dependencies] Stack: $stackTrace');

    // Still register a dummy service so app doesn't crash
    // The app will work, just without push notifications
    Get.put(NotificationService(), permanent: true);
    print(
      '[Dependencies] Registered dummy NotificationService - app will continue',
    );
  }
}
