# https://github.com/nemequ/hedley
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "v15")
endif ()

CPMAddPackage(
        NAME hedley
        GITHUB_REPOSITORY nemequ/hedley
        GIT_TAG ${HANDLE_EXTERNALS_VERSION}
        DOWNLOAD_ONLY
)

#  we must create the target on our own because the creator is not into modern cmake currently
if (hedley_ADDED)
    add_library(hedley INTERFACE IMPORTED)

    target_precompile_headers(hedley INTERFACE ${hedley_SOURCE_DIR}/hedley.h)

    target_include_directories(
            hedley
            SYSTEM INTERFACE
            $<BUILD_INTERFACE:${hedley_SOURCE_DIR}>
            $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>)

    message(DEBUG "Hedley ${HANDLE_EXTERNALS_VERSION} created")
endif()

if(NOT TARGET hedley)
    message(WARNING "Hedley ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
