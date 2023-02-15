# libsecret using meson and will likely not get a find_package so we find the library and create our own cmake target
include(${currentFolder}/externals/helpers/FindLibsecret.cmake)
add_library(libsecret INTERFACE)
target_include_directories(libsecret SYSTEM INTERFACE ${LIBSECRET_INCLUDE_DIRS})
target_link_libraries(libsecret INTERFACE ${LIBSECRET_LIBRARIES})
