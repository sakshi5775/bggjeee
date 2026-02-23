class GlobalApiStore {
  static final Map<String, dynamic> _cache = {};

  static bool has(String key) => _cache.containsKey(key);

  static dynamic get(String key) => _cache[key];

  static void set(String key, dynamic data) {
    _cache[key] = data;
  }

  static void clear() {
    _cache.clear();
  }
}
