find_package(ZLIB QUIET)

# If Zlib is not found, download and build it as an external project
if(NOT ZLIB_FOUND)
    message(STATUS "Try to install Zlib")
    if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
        set(HANDLE_EXTERNALS_VERSION "1.2.13")
    endif ()
    set(buffer ${CMAKE_INTERPROCEDURAL_OPTIMIZATION})
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION OFF)
    set(CMAKE_POLICY_DEFAULT_CMP0048 NEW)
    CPMAddPackage(
            NAME zlib
            GITHUB_REPOSITORY madler/zlib
            GIT_TAG v${HANDLE_EXTERNALS_VERSION}
    )
    set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ${buffer})
    unset(buffer)
    add_library(ZLIB::ZLIB ALIAS zlib)
endif()
