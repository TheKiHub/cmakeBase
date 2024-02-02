# https://github.com/marzer/tomlplusplus
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "3.4.0")
endif ()

CPMAddPackage(
        NAME tomlplusplus_tomlplusplus
        GITHUB_REPOSITORY marzer/tomlplusplus
        VERSION ${HANDLE_EXTERNALS_VERSION}
)

if (tomlplusplus_tomlplusplus_ADDED)
    # installation is only possible if this project is the main project, make it installable also when included
    packageProject(
            NAME tomlplusplus_tomlplusplus
            VERSION 3.2.0
            BINARY_DIR ${CMAKE_BINARY_DIR}/_deps/tomlplusplus_tomlplusplus-build
            INCLUDE_DIR ${tomlplusplus_tomlplusplus_SOURCE_DIR}/include
            INCLUDE_DESTINATION include/
            VERSION_HEADER "tomlplusplus_tomlplusplus/version.h"
            COMPATIBILITY SameMajorVersion
    )

    message(DEBUG "tomlplusplus_tomlplusplus ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "tomlplusplus_tomlplusplus ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
