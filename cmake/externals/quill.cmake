# https://github.com/odygrd/quill
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "11.0.1")
endif ()

CPMAddPackage(
        NAME quill
        GITHUB_REPOSITORY odygrd/quill
        VERSION ${HANDLE_EXTERNALS_VERSION}
)

if (quill_ADDED)
    # turn off all kinds of warnings by including the headers as system headers
    include_as_systemheaders(quill)

    option(QUILL_REMOVE_META_DATA "Configure Quill to remove function meta data and file meta data in release mode" ON)
    if(QUILL_REMOVE_META_DATA)
        # we don't use function names in the log, function names needs a special treatment inside a lambda which most forget
        # also it creates a warning in tidy clang
        target_compile_options(quill INTERFACE -DQUILL_DISABLE_FUNCTION_NAME)
        target_compile_options(quill INTERFACE
                "$<$<CONFIG:RELEASE,MINSIZEREL>:-DQUILL_DISABLE_FILE_INFO>" # file info is only important in development (RELWITHDEBINFO is for development)
        )
    endif ()

    option(QUILL_REMOVE_LOW_SEVERITY_LOGS_RELEASE_ONLY "Configure Quill to remove log commands with severity lower than 'info' in release mode" ON)
    if(QUILL_REMOVE_LOW_SEVERITY_LOGS_RELEASE_ONLY)
        # Configure Quill to remove log commands with severity lower than "info" in release mode.
        # This will improve performance and result in smaller binary sizes.
        # It's important to have this configuration active for all targets created with Quill. Since global flags are not
        # recommended, we define it here. However, if you want to use a different behavior for a specific target, you can
        # override the QUILL_COMPILE_ACTIVE_LOG_LEVEL.
        target_compile_options(quill INTERFACE "$<$<CONFIG:RELEASE,RELWITHDEBINFO,MINSIZEREL>:-DQUILL_COMPILE_ACTIVE_LOG_LEVEL=QUILL_COMPILE_ACTIVE_LOG_LEVEL_INFO>")
        message(DEBUG "quill ${HANDLE_EXTERNALS_VERSION} with release features created")
    else ()
        message(DEBUG "quill ${HANDLE_EXTERNALS_VERSION} created")
    endif ()
endif()

if(NOT TARGET quill)
    message(WARNING "quill ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
