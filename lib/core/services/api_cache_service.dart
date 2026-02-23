import 'package:get_storage/get_storage.dart';

class ApiCacheService {
  // Use lazy getter to ensure the box is accessed only after GetStorage.init() in main()
  static GetStorage get _box => GetStorage('api_cache');

  static Future<void> save(String key, dynamic data) async {
    await _box.write(key, {
      "data": data,
      "time": DateTime.now().millisecondsSinceEpoch,
    });
  }

  static dynamic get(String key, {int maxAgeMinutes = 30}) {
    final cached = _box.read(key);
    if (cached == null) return null;

    final time = cached["time"];
    if (time == null) return null;

    final now = DateTime.now().millisecondsSinceEpoch;
    final diffMinutes = (now - time) / 60000;

    if (diffMinutes > maxAgeMinutes) {
      _box.remove(key);
      return null;
    }

    return cached["data"];
  }

  static void clear() {
    _box.erase();
  }
}
