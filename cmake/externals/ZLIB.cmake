find_package(ZLIB QUIET)

# If Zlib is not found, download and build it as an external project
if(NOT ZLIB_FOUND)
    message(STATUS "try to install Zlib")
    if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
        set(HANDLE_EXTERNALS_VERSION "1.2.13")
    endif ()

    CPMAddPackage(
            NAME zlib
            GITHUB_REPOSITORY madler/zlib
            GIT_TAG v${HANDLE_EXTERNALS_VERSION}
    )
    set_target_properties(zlib PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
    add_library(ZLIB::ZLIB ALIAS zlib)
endif()
