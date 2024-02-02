# https://github.com/taskflow/taskflow
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "3.6.0")
endif ()

CPMAddPackage(
        NAME Taskflow
        GITHUB_REPOSITORY taskflow/taskflow
        VERSION ${HANDLE_EXTERNALS_VERSION}
        OPTIONS
        "TF_BUILD_TESTS Off"
        "TF_BUILD_EXAMPLES Off"
)

if (Taskflow_ADDED)
    target_include_directories(Taskflow
            SYSTEM INTERFACE
            $<INSTALL_INTERFACE:include/>
            $<BUILD_INTERFACE:${Taskflow_SOURCE_DIR}>
            )
    message(DEBUG "Taskflow ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "Taskflow ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
