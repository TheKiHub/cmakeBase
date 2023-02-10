# libsecret using meson and will likely not get a find_package so we find the library and create our own cmake target
add_library(libTest INTERFACE)
target_include_directories(libTest SYSTEM INTERFACE ${LIBSECRET_INCLUDE_DIRS})
target_link_libraries(libTest INTERFACE ${LIBSECRET_LIBRARIES})
