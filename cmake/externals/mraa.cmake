# https://github.com/eclipse/mraa
# mraa don't work on every platform, some platforms (like radxa zero) have their own implementation which we can
# install and then use with findPackage
option(IGNORE_SYSTEM_LIBRARY_MRAA "Ignore the system-installed mraa library" OFF)

if(NOT IGNORE_SYSTEM_LIBRARY_MRAA)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(MRAA REQUIRED mraa)

    find_path(Mraa_INCLUDE_DIR
            NAMES mraa.h
            PATH ${MRAA_INCLUDE_DIRS}
            )

    find_library(Mraa_LIBRARY
            NAMES libmraa.so
            PATH ${MRAA_LIBRARY_DIRS}
            )

    set(Mraa_VERSION ${MRAA_VERSION})

    mark_as_advanced(Mraa_FOUND Mraa_INCLUDE_DIR Mraa_LIBRARY Mraa_VERSION)

    include(FindPackageHandleStandardArgs)
    find_package_handle_standard_args(Mraa
            REQUIRED Mraa_INCLUDE_DIR
            REQUIRED Mraa_LIBRARY
            VERSION_VAR Mraa_VERSION
            )
endif ()

if (Mraa_FOUND)
    set(Mraa_INCLUDE_DIRS {Mraa_INCLUDE_DIR})
    set(Mraa_LIBRARIES {Mraa_LIBRARY})
    if (NOT TARGET mraa::mraa)
        add_library(mraa::mraa UNKNOWN IMPORTED)
        set_target_properties(mraa::mraa PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${Mraa_INCLUDE_DIRS}"
                IMPORTED_LOCATION "${Mraa_LIBRARIES}"
                )
        set_target_properties(mraa::mraa PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
        message(STATUS "Using mraa library installed on this system")
    endif ()
else()
    # check if special Version is used or set the standard version
    if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
        set(HANDLE_EXTERNALS_VERSION "2.2.0")
    endif ()

    set(CMAKE_POLICY_BUFFER ${CMAKE_POLICY_DEFAULT_CMP0048})
    set(CMAKE_POLICY_DEFAULT_CMP0048 NEW) # deactivate PROJECT_VERSION warnings
    set(CMAKE_MESSAGE_LOG_LEVEL "ERROR")    # deactivate the stupid git warning message
    CPMAddPackage(
            NAME mraa
            GITHUB_REPOSITORY eclipse/mraa
            VERSION ${HANDLE_EXTERNALS_VERSION}
            OPTIONS
            "BUILDSWIG OFF"
            "BUILDSWIGPYTHON OFF"
            "JSONPLAT OFF"
            "INSTALLTOOLS OFF"
            "BUILDTESTS OFF"
            "ENABLEEXAMPLES OFF"
    )
    set(CMAKE_MESSAGE_LOG_LEVEL "STATUS")
    set(CMAKE_POLICY_DEFAULT_CMP0048 ${CMAKE_POLICY_BUFFER}) # revert the policy change

    if (mraa_ADDED)
        set_target_properties(mraa PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it

        get_property(MRAA_BINARY_DIR TARGET mraa PROPERTY BINARY_DIR)
        string(TOLOWER mraa/version.h VERSION_HEADER_LOCATION)
        packageProject(
                NAME mraa
                VERSION ${HANDLE_EXTERNALS_VERSION}
                BINARY_DIR ${MRAA_BINARY_DIR}
                INCLUDE_DIR ${mraa_SOURCE_DIR}
                INCLUDE_DESTINATION include/mraa-${HANDLE_EXTERNALS_VERSION}
                INCLUDE_HEADER_PATTERN "*.h"
                VERSION_HEADER "${VERSION_HEADER_LOCATION}"
                COMPATIBILITY SameMajorVersion
                DEPENDENCIES ""
        )
        message(DEBUG "mraa ${HANDLE_EXTERNALS_VERSION} created")
    else ()
        message(WARNING "mraa ${HANDLE_EXTERNALS_VERSION} could not be created")
    endif ()
endif()
