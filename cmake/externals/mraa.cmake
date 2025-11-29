# https://github.com/eclipse/mraa
# mraa don't work on every platform, some platforms (like radxa zero) have their own implementation which we can
# install and then use with findPackage
option(IGNORE_SYSTEM_LIBRARY_MRAA "Ignore the system-installed mraa library" OFF)

if(NOT IGNORE_SYSTEM_LIBRARY_MRAA)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(MRAA mraa)

    if(MRAA_PKG_FOUND)
        find_path(Mraa_INCLUDE_DIR
                NAMES mraa.h
                HINTS ${MRAA_PKG_INCLUDE_DIRS}
        )

        find_library(Mraa_LIBRARY
                NAMES mraa
                HINTS ${MRAA_PKG_LIBRARY_DIRS}
        )

        set(Mraa_VERSION ${MRAA_PKG_VERSION})

        mark_as_advanced(Mraa_FOUND Mraa_INCLUDE_DIR Mraa_LIBRARY Mraa_VERSION)

        include(FindPackageHandleStandardArgs)

        # This will set Mraa_FOUND to TRUE only if INCLUDE_DIR and LIBRARY are valid
        find_package_handle_standard_args(Mraa
                REQUIRED_VARS Mraa_INCLUDE_DIR Mraa_LIBRARY
                VERSION_VAR Mraa_VERSION
        )
    endif()
endif ()

if (Mraa_FOUND)
    set(Mraa_INCLUDE_DIRS ${Mraa_INCLUDE_DIR})
    set(Mraa_LIBRARIES ${Mraa_LIBRARY})
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

    # --- SAVE STATE ---
    set(CMP0048_BUFFER ${CMAKE_POLICY_DEFAULT_CMP0048})
    set(WARN_DEPRECATED_BUFFER ${CMAKE_WARN_DEPRECATED})
    set(LOG_LEVEL_BUFFER ${CMAKE_MESSAGE_LOG_LEVEL})

    # --- SUPPRESS WARNINGS ---
    set(CMAKE_POLICY_DEFAULT_CMP0048 NEW) # Fixes project() version warning
    set(CMAKE_WARN_DEPRECATED OFF)        # Fixes cmake_minimum_required warning
    set(CMAKE_MESSAGE_LOG_LEVEL "ERROR")  # Fixes git clone spam

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

    # --- RESTORE STATE ---
    set(CMAKE_MESSAGE_LOG_LEVEL ${LOG_LEVEL_BUFFER})
    set(CMAKE_POLICY_DEFAULT_CMP0048 ${CMP0048_BUFFER})
    set(CMAKE_WARN_DEPRECATED ${WARN_DEPRECATED_BUFFER})

    if (mraa_ADDED)
        set_target_properties(mraa PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
        target_compile_options(mraa PRIVATE -fcommon) # fix double version problem on some platforms

        target_include_directories(mraa PUBLIC $<BUILD_INTERFACE:${mraa_SOURCE_DIR}/api>)
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
    endif()
endif()

if(NOT TARGET mraa)
    message(WARNING "mraa ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
