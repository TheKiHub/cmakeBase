if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "20.36.0")
endif ()

CPMAddPackage(
        NAME uSockets
        GITHUB_REPOSITORY uNetworking/uSockets
        GIT_TAG v0.8.5
        DOWNLOAD_ONLY
)

if (uSockets_ADDED)
    # uSockets don't support CMake so we create our own target for bedder usage
    project(uSockets VERSION 0.8.5)
    AUX_SOURCE_DIRECTORY(${uSockets_SOURCE_DIR}/src SOURCES)
    AUX_SOURCE_DIRECTORY(${uSockets_SOURCE_DIR}/src/crypto SOURCES)
    AUX_SOURCE_DIRECTORY(${uSockets_SOURCE_DIR}/src/eventing SOURCES)

    add_library(${PROJECT_NAME}
            ${SOURCES}
            )

    # turn off all kinds of warnings
    inhibit_target_warnings(${PROJECT_NAME})

    # make the headers system, targets which include it should not get warnings
    target_include_directories(${PROJECT_NAME}
            SYSTEM PUBLIC
            $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
            $<BUILD_INTERFACE:${uSockets_SOURCE_DIR}/src>
            )

    handleExternals(NAME OpenSSL)

    # Standard FIND_PACKAGE module for libuv, sets the following variables:
    #   - LIBUV_FOUND
    #   - LIBUV_INCLUDE_DIRS (only if LIBUV_FOUND)
    #   - LIBUV_LIBRARIES (only if LIBUV_FOUND)

    # Try to find the header
    FIND_PATH(LIBUV_INCLUDE_DIR HINTS "${LIBUV_DIR}" NAMES uv.h REQUIRED)

    # Try to find the library
    FIND_LIBRARY(LIBUV_LIBRARY HINTS "${LIBUV_DIR}" NAMES uv libuv REQUIRED)

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
    endif()

    target_link_libraries(${PROJECT_NAME}
            PUBLIC
                OpenSSL::SSL
                libuv
            )

    target_compile_definitions(${PROJECT_NAME} PUBLIC LIBUS_USE_OPENSSL WITH_LIBUV)
    message(DEBUG "uSockets ${HANDLE_EXTERNALS_VERSION} created")

    #-------------------------------------------------------------------------------------------------------
    # When uSockets is created we can start creating uWebSockets
    #-------------------------------------------------------------------------------------------------------
    CPMAddPackage(
            NAME uWebSockets
            GITHUB_REPOSITORY uNetworking/uWebSockets
            GIT_TAG v${HANDLE_EXTERNALS_VERSION}
            DOWNLOAD_ONLY
    )

    if (uWebSockets_ADDED)
        project(uWebSockets VERSION ${HANDLE_EXTERNALS_VERSION})

        ADD_LIBRARY(${PROJECT_NAME} INTERFACE)

        handleExternals(NAME ZLIB)
        target_link_libraries(${PROJECT_NAME}
                INTERFACE
                ZLIB::ZLIB
                uSockets)

        #use system to turn off all warnings so we don't get spammed from this external library (mostly c-style warnings)
        target_include_directories(${PROJECT_NAME}
                SYSTEM INTERFACE
                $<INSTALL_INTERFACE:include>
                $<BUILD_INTERFACE:${uWebSockets_SOURCE_DIR}/src>
                )
        message(DEBUG "uWebSockets ${HANDLE_EXTERNALS_VERSION} created")
    else ()
        message(WARNING "uWebSockets ${HANDLE_EXTERNALS_VERSION} could not be created")
    endif ()
else ()
    message(WARNING "uSockets ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()