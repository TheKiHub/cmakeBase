# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "94e850fd6ff9eceb98fda3147e3ffd4781ad2dc7") # using the hash to get a specific version in docking
endif ()

CPMAddPackage(
        NAME IMGUI
        GITHUB_REPOSITORY ocornut/imgui
        GIT_TAG ${HANDLE_EXTERNALS_VERSION}
)

if (IMGUI_ADDED)
    # ImGui don't support CMake so we create our own target for bedder usage
    project(imGui VERSION 1.89)

    add_library(${PROJECT_NAME}
            ${IMGUI_SOURCE_DIR}/imgui.cpp
            ${IMGUI_SOURCE_DIR}/imgui_draw.cpp
            ${IMGUI_SOURCE_DIR}/imgui_tables.cpp
            ${IMGUI_SOURCE_DIR}/imgui_widgets.cpp
            ${IMGUI_SOURCE_DIR}/misc/cpp/imgui_stdlib.cpp
            ${IMGUI_SOURCE_DIR}/backends/imgui_impl_opengl3.cpp
            ${IMGUI_SOURCE_DIR}/backends/imgui_impl_glfw.cpp
            )

    # turn off all kinds of warnings
    inhibit_target_warnings(${PROJECT_NAME})

    # make the headers system, targets which include it should not get warnings
    target_include_directories(${PROJECT_NAME}
            SYSTEM PUBLIC
            $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
            $<BUILD_INTERFACE:${IMGUI_SOURCE_DIR}>
            $<BUILD_INTERFACE:${IMGUI_SOURCE_DIR}/misc/cpp/>
            $<BUILD_INTERFACE:${IMGUI_SOURCE_DIR}/backends/>
            )

    handleExternals(NAME glfw)

    target_link_libraries(${PROJECT_NAME}
            PUBLIC
            glfw
            )

    string(TOLOWER ${PROJECT_NAME}/version.h VERSION_HEADER_LOCATION)

    packageProject(
            NAME ${PROJECT_NAME}
            VERSION ${PROJECT_VERSION}
            BINARY_DIR ${PROJECT_BINARY_DIR}
            INCLUDE_DIR ${IMGUI_SOURCE_DIR}
            INCLUDE_DESTINATION include/${PROJECT_NAME}-${PROJECT_VERSION}
            INCLUDE_HEADER_PATTERN "*.h"
            VERSION_HEADER "${VERSION_HEADER_LOCATION}"
            COMPATIBILITY SameMajorVersion
            DEPENDENCIES "glfw 3.3"
    )
    message(DEBUG "IMGUI ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "IMGUI ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
