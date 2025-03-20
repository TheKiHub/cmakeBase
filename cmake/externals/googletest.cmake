# https://github.com/google/googletest
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "1.16.0")
endif ()

CPMAddPackage(
        NAME googletest
        GITHUB_REPOSITORY google/googletest
        VERSION ${HANDLE_EXTERNALS_VERSION}
)

if (googletest_ADDED)
    message(DEBUG "googletest ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "googletest ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
