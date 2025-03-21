# https://github.com/freetype/freetype
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "VER-2-13-3")
endif ()

CPMAddPackage(
        NAME freetype
        GITHUB_REPOSITORY freetype/freetype
        GIT_TAG ${HANDLE_EXTERNALS_VERSION}
)

if (freetype_ADDED)
    add_library(Freetype::Freetype ALIAS freetype)
    set_target_properties(freetype PROPERTIES INTERPROCEDURAL_OPTIMIZATION OFF) # don't support it
    message(DEBUG "freetype ${HANDLE_EXTERNALS_VERSION} created")
endif ()

if(NOT TARGET freetype)
    message(WARNING "freetype ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
