# https://github.com/madler/zlib
# check if special version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "1.3.1")
endif ()

option(IGNORE_SYSTEM_LIBRARY_ZLIB "Ignore the system-installed mraa library" OFF)

if(NOT IGNORE_SYSTEM_LIBRARY_ZLIB)
    find_package(ZLIB QUIET)
endif()

# If Zlib is not found, download and build it as an external project
if(NOT ZLIB_FOUND)
    message(STATUS "Try to install Zlib")
    set(buffer ${CMAKE_INTERPROCEDURAL_OPTIMIZATION})
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION OFF)
    set(CMAKE_POLICY_DEFAULT_CMP0048 NEW)
    CPMAddPackage(
            NAME zlib
            GITHUB_REPOSITORY madler/zlib
            VERSION ${HANDLE_EXTERNALS_VERSION}
    )
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ${buffer})
    unset(buffer)
    add_library(ZLIB::ZLIB ALIAS zlib)
else()
    message(STATUS "Using ZLIB library installed on this system")
endif()
