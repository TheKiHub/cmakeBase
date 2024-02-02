# https://github.com/glfw/glfw
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "3.3.9")
endif ()

CPMAddPackage(
        NAME GLFW
        GITHUB_REPOSITORY glfw/glfw
        GIT_TAG ${HANDLE_EXTERNALS_VERSION}
        OPTIONS
        "GLFW_BUILD_TESTS OFF"
        "GLFW_BUILD_EXAMPLES OFF"
        "GLFW_BULID_DOCS OFF"
)


if (GLFW_ADDED)
    message(DEBUG "GLFW ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "GLFW ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
