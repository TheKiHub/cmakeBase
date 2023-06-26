# check if special version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "1.45.0")
endif ()

option(IGNORE_SYSTEM_LIBRARY_LIBUV "Ignore the system-installed mraa library" OFF)

if (NOT IGNORE_SYSTEM_LIBRARY_LIBUV)
    # Try to find the header
    find_library(LibUV_LIBRARY
                NAMES uv
            )

    # Try to find the library
    find_path(LibUV_INCLUDE_DIR
            NAMES uv.h
            )
    # Hide internal variables
    MARK_AS_ADVANCED(LIBUV_INCLUDE_DIR LIBUV_LIBRARY)

    #-----------------------------------------------------------------------------
    include(FindPackageHandleStandardArgs)
    FIND_PACKAGE_HANDLE_STANDARD_ARGS(LibUV
            FOUND_VAR LibUV_FOUND
            REQUIRED_VARS LibUV_LIBRARY LibUV_INCLUDE_DIR
            VERSION_VAR LibUV_VERSION
            )
    set(LIBUV_FOUND ${LibUV_FOUND})
endif ()

#TODO check if found version is the right one
if(LibUV_FOUND)
    set(LibUV_INCLUDE_DIRS ${LibUV_INCLUDE_DIR})
    set(LibUV_LIBRARIES ${LibUV_LIBRARY})
    if(NOT TARGET LibUV::LibUV)
        add_library(LibUV::LibUV UNKNOWN IMPORTED)
        set_target_properties(LibUV::LibUV PROPERTIES
                IMPORTED_LOCATION "${LibUV_LIBRARY}"
                INTERFACE_INCLUDE_DIRECTORIES "${LibUV_INCLUDE_DIRS}"
                )
        add_library(libuv ALIAS LibUV::LibUV)
        message(STATUS "Using LibUV library installed on this system")
    endif()
else()
    CPMAddPackage(
            NAME libuv
            GITHUB_REPOSITORY libuv/libuv
            GIT_TAG v${HANDLE_EXTERNALS_VERSION}
            OPTIONS LIBUV_BUILD_TESTS=OFF
    )
    set_target_properties(uv_a PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
    set_target_properties(uv PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
    add_library(libuv ALIAS uv)
endif()
