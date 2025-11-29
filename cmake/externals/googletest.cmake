# https://github.com/google/googletest
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "1.17.0")
endif ()

CPMAddPackage(
        NAME googletest
        GITHUB_REPOSITORY google/googletest
        VERSION ${HANDLE_EXTERNALS_VERSION}
        OPTIONS
        "GTEST_HAS_ABSL OFF"
)

if (googletest_ADDED)
    add_library(googletest ALIAS gtest_main)
    message(DEBUG "googletest ${HANDLE_EXTERNALS_VERSION} created")
endif()

if(NOT TARGET googletest)
    message(WARNING "googletest ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
