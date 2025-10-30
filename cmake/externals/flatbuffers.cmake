# https://github.com/google/flatbuffers
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "25.9.23")
endif()

CPMAddPackage(
        NAME flatbuffers
        GITHUB_REPOSITORY google/flatbuffers
        VERSION ${HANDLE_EXTERNALS_VERSION}
        OPTIONS
        "FLATBUFFERS_BUILD_TESTS OFF"
        "FLATBUFFERS_INSTALL OFF"
)

if (flatbuffers_ADDED)
    set(${flatbuffers_SOURCE_DIR} ${flatbuffers_SOURCE_DIR} PARENT_SCOPE)
    message(DEBUG "flatbuffers ${HANDLE_EXTERNALS_VERSION} created")
endif ()

if(NOT TARGET flatbuffers)
    message(WARNING "flatbuffers ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
