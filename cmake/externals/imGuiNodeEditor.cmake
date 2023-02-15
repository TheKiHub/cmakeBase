# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "99ec923a39062f556ec7676fb9ba6d302d109f76")
endif ()

CPMAddPackage(
        NAME imGuiNodeEditor
        GITHUB_REPOSITORY thedmd/imgui-node-editor
        GIT_TAG ${HANDLE_EXTERNALS_VERSION}
        DOWNLOAD_ONLY
)

if (imGuiNodeEditor_ADDED)
    project(imGuiNodeEditor VERSION 1.0)

    add_library(${PROJECT_NAME}
            ${imGuiNodeEditor_SOURCE_DIR}/crude_json.h
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_bezier_math.h
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_bezier_math.inl
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_canvas.h
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_extra_math.h
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_extra_math.inl
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_node_editor_internal.h
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_node_editor_internal.inl
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_node_editor.h
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_canvas.cpp
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_node_editor.cpp
            ${imGuiNodeEditor_SOURCE_DIR}/imgui_node_editor_api.cpp
            ${imGuiNodeEditor_SOURCE_DIR}/crude_json.cpp
            )

    #Set target properties
    target_include_directories(${PROJECT_NAME}
            SYSTEM PUBLIC
            $<BUILD_INTERFACE:${imGuiNodeEditor_SOURCE_DIR}>
            $<INSTALL_INTERFACE:include/${PROJECT_NAME}-${PROJECT_VERSION}>
            )

    handleExternals(NAME imGui)

    target_link_libraries(${PROJECT_NAME}
            PUBLIC
            imGui
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
            DEPENDENCIES "imGui 1.8"
    )
    message(DEBUG "imGuiNodeEditor ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "imGuiNodeEditor ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
