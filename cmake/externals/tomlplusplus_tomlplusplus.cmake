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
    # turn off all kinds of warnings by including the headers as system headers
    target_include_directories(tomlplusplus_tomlplusplus
            SYSTEM INTERFACE
            $<BUILD_INTERFACE:${tomlplusplus_tomlplusplus_SOURCE_DIR}/include>
            $<INSTALL_INTERFACE:include>)

    message(DEBUG "tomlplusplus_tomlplusplus ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "tomlplusplus_tomlplusplus ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
