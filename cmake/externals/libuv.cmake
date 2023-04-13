# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "1.44.2")
endif ()

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
    endif()
    add_library(libuv ALIAS LibUV::LibUV)
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
