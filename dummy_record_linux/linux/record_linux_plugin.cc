// Dummy implementation for record_linux plugin
// This file exists to satisfy Flutter plugin requirements

#include <flutter_linux/flutter_linux.h>

G_DEFINE_TYPE(RecordLinuxPlugin, record_linux_plugin, g_object_get_type())

static void record_linux_plugin_class_init(RecordLinuxPluginClass* klass) {}

static void record_linux_plugin_init(RecordLinuxPlugin* self) {}

void record_linux_plugin_register_with_registrar(FlPluginRegistrar* registrar) {
  // Dummy registration - no actual functionality
}




