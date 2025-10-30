# https://github.com/google/flatbuffers
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "25.9.23")
endif()

CPMAddPackage(
        NAME flatcBinary
        URL https://github.com/google/flatbuffers/releases/download/v${HANDLE_EXTERNALS_VERSION}/Windows.flatc.binary.zip
        DOWNLOAD_ONLY
)

if (EXISTS ${flatcBinary_SOURCE_DIR})
    set(flatcBinary_SOURCE_DIR ${flatcBinary_SOURCE_DIR} PARENT_SCOPE)
    message(DEBUG "flatcBinary ${HANDLE_EXTERNALS_VERSION} downloaded")
else ()
    message(WARNING "flatcBinary ${HANDLE_EXTERNALS_VERSION} could not be downloaded")
endif ()
