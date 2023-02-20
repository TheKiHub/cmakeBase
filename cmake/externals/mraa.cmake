# mraa don't work on every platform, some platforms (like radxa zero) have their own implementation which we can
# install and then use with findPackage
option(MRAA_USE_FIND_PACKAGE "Use find package to find mraa, needs to be installed on the platform" OFF)

if(MRAA_USE_FIND_PACKAGE)
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

    if (Mraa_FOUND)
        set(Mraa_INCLUDE_DIRS {Mraa_INCLUDE_DIR})
        set(Mraa_LIBRARIES {Mraa_LIBRARY})
    endif ()

    if (Mraa_FOUND AND NOT TARGET mraa::mraa)
        add_library(mraa::mraa UNKNOWN IMPORTED)
        set_target_properties(mraa::mraa PROPERTIES
                INTERFACE_INCLUDE_DIRECTORIES "${Mraa_INCLUDE_DIRS}"
                IMPORTED_LOCATION "${Mraa_LIBRARIES}"
                )
        set_target_properties(mraa::mraa PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
    endif ()
else()
    # check if special Version is used or set the standard version
    if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
        set(HANDLE_EXTERNALS_VERSION "8b1c549")
    endif ()

    set(CMAKE_MESSAGE_LOG_LEVEL "ERROR")    # deactivate the stupid git warning message
    CPMAddPackage(
            NAME mraa
            GITHUB_REPOSITORY eclipse/mraa
            GIT_TAG ${HANDLE_EXTERNALS_VERSION}
            OPTIONS
                "BUILDSWIG OFF"
                "BUILDSWIGPYTHON OFF"
                "JSONPLAT OFF"
                "INSTALLTOOLS OFF"
                "BUILDTESTS OFF"
                "ENABLEEXAMPLES OFF"
    )
    set(CMAKE_MESSAGE_LOG_LEVEL "STATUS")

    if (mraa_ADDED)
        set_target_properties(mraa PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
        message(DEBUG "mraa ${HANDLE_EXTERNALS_VERSION} created")
    else ()
        message(WARNING "mraa ${HANDLE_EXTERNALS_VERSION} could not be created")
    endif ()
endif()