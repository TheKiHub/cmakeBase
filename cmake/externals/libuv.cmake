# Standard FIND_PACKAGE module for libuv, sets the following variables:
#   - LIBUV_FOUND
#   - LIBUV_INCLUDE_DIRS (only if LIBUV_FOUND)
#   - LIBUV_LIBRARIES (only if LIBUV_FOUND)

# Try to find the header
FIND_PATH(LIBUV_INCLUDE_DIR NAMES uv.h)

# Try to find the library
FIND_LIBRARY(LIBUV_LIBRARY NAMES uv libuv)

# Handle the QUIETLY/REQUIRED arguments, set LIBUV_FOUND if all variables are
# found
INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(LIBUV
        REQUIRED_VARS
        LIBUV_LIBRARY
        LIBUV_INCLUDE_DIR)

# Hide internal variables
MARK_AS_ADVANCED(LIBUV_INCLUDE_DIR LIBUV_LIBRARY)

if(LibUV_FOUND)
    set(LibUV_INCLUDE_DIRS ${LibUV_INCLUDE_DIR})
    set(LibUV_LIBRARIES ${LibUV_LIBRARY})
    if(NOT TARGET libuv)
        add_library(libuv UNKNOWN IMPORTED)
        set_target_properties(libuv PROPERTIES
            IMPORTED_LOCATION "${LibUV_LIBRARY}"
            INTERFACE_INCLUDE_DIRECTORIES "${LibUV_INCLUDE_DIRS}"
        )
    endif()
else()
    CPMAddPackage(
            NAME libuv
            GITHUB_REPOSITORY libuv/libuv
            GIT_TAG v1.44.2
            OPTIONS LIBUV_BUILD_TESTS=OFF
    )
    set_target_properties(uv_a PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
    set_target_properties(uv PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
    add_library(libuv ALIAS uv)
endif()

