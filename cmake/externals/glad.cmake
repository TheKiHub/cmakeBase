# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "2.0.2")
endif ()

CPMAddPackage(
        NAME glad
        GITHUB_REPOSITORY Dav1dde/glad
        GIT_TAG ${HANDLE_EXTERNALS_VERSION}
)

if (glad_ADDED)
    message(DEBUG "glad ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "glad ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
