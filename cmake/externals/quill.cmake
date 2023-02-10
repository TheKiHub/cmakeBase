# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "2.5.1")
endif ()

# quill needs to set the CMAKE_MODULE_PATH which don't work with CPM (policy CMP0126 NEW) as a workaround we unset the module path
unset(CMAKE_MODULE_PATH)
CPMAddPackage(
        NAME quill
        GITHUB_REPOSITORY odygrd/quill
        VERSION ${HANDLE_EXTERNALS_VERSION}
        OPTIONS "QUILL_ENABLE_INSTALL ON"
)


if (quill_ADDED)
    # after quill is added we don't want the modules in our cache
    unset(CMAKE_MODULE_PATH CACHE)

    # turn off all kinds of warnings
    inhibit_target_warnings(quill)
    target_include_directories(quill
            SYSTEM PUBLIC
            $<BUILD_INTERFACE:${quill_SOURCE_DIR}/quill/include>
            $<INSTALL_INTERFACE:include>
            PRIVATE
            ${quill_SOURCE_DIR}/quill)
    target_compile_features(quill PUBLIC cxx_std_17)
    message(DEBUG "quill ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "quill ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
