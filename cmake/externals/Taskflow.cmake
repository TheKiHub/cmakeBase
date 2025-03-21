# https://github.com/taskflow/taskflow
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "3.9.0")
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
    # turn off all kinds of warnings by including the as system headers
    include_as_systemheaders(Taskflow)

    message(DEBUG "Taskflow ${HANDLE_EXTERNALS_VERSION} created")
endif()

if(NOT TARGET Taskflow)
    message(WARNING "Taskflow ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
