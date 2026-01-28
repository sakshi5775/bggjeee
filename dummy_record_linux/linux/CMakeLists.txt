cmake_minimum_required(VERSION 3.10)
project(record_linux LANGUAGES CXX)

add_library(record_linux_plugin SHARED
  record_linux_plugin.cc
)

target_link_libraries(record_linux_plugin PRIVATE flutter)

install(TARGETS record_linux_plugin DESTINATION "${INSTALL_BUNDLE_LIB_DIR}")




