if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "20.74.0")
endif ()

CPMAddPackage(
        NAME uSockets
        GITHUB_REPOSITORY uNetworking/uSockets
        VERSION 0.8.8
        DOWNLOAD_ONLY
)

if (uSockets_ADDED)
    # uSockets don't support CMake so we create our own target for bedder usage
    project(uSockets VERSION 0.8.8)
    AUX_SOURCE_DIRECTORY(${CPM_PACKAGE_uSockets_SOURCE_DIR}/src SOURCES)
    AUX_SOURCE_DIRECTORY(${CPM_PACKAGE_uSockets_SOURCE_DIR}/src/crypto SOURCES)
    AUX_SOURCE_DIRECTORY(${CPM_PACKAGE_uSockets_SOURCE_DIR}/src/eventing SOURCES)

    add_library(${PROJECT_NAME}
            ${SOURCES}
            )

    # turn off all kinds of warnings
    inhibit_target_warnings(${PROJECT_NAME})

    # make the headers system, targets which include it should not get warnings
    target_include_directories(${PROJECT_NAME}
            SYSTEM PUBLIC
            $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
            $<BUILD_INTERFACE:${CPM_PACKAGE_uSockets_SOURCE_DIR}/src>
            )

    handleExternals(NAME OpenSSL)
    handleExternals(NAME libuv)
    target_link_libraries(${PROJECT_NAME}
            PUBLIC
                OpenSSL::SSL
                libuv
            )

    target_compile_definitions(${PROJECT_NAME} PUBLIC LIBUS_USE_OPENSSL=1 WITH_LIBUV=1)
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
        option(UWEBSOCKETS_WITH_ZLIB "Should the uWebSockets get zlib support" OFF)
        project(uWebSockets VERSION ${HANDLE_EXTERNALS_VERSION})

        ADD_LIBRARY(${PROJECT_NAME} INTERFACE)

        target_link_libraries(${PROJECT_NAME}
                INTERFACE
                uSockets)

        #use system to turn off all warnings so we don't get spammed from this external library (mostly c-style warnings)
        target_include_directories(${PROJECT_NAME}
                SYSTEM INTERFACE
                    $<INSTALL_INTERFACE:include>
                    $<BUILD_INTERFACE:${CPM_PACKAGE_uWebSockets_SOURCE_DIR}/src>
                )

        if(UWEBSOCKETS_WITH_ZLIB)
            handleExternals(NAME ZLIB)
            target_link_libraries(${PROJECT_NAME}
                    INTERFACE
                    ZLIB::ZLIB)
            target_compile_definitions(${PROJECT_NAME} INTERFACE UWS_NO_ZLIB=0)
        else()
            target_compile_definitions(${PROJECT_NAME} INTERFACE UWS_NO_ZLIB=1)
        endif()

        message(DEBUG "uWebSockets ${HANDLE_EXTERNALS_VERSION} created")
    else ()
        message(WARNING "uWebSockets ${HANDLE_EXTERNALS_VERSION} could not be created")
    endif ()
else ()
    message(WARNING "uSockets ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()