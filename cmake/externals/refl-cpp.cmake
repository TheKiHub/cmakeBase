# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "0.12.3")
endif ()

CPMAddPackage(
        NAME refl-cpp
        GITHUB_REPOSITORY veselink1/refl-cpp
        VERSION ${HANDLE_EXTERNALS_VERSION}
)

if (refl-cpp_ADDED)
    message(DEBUG "refl-cpp ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "refl-cpp ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
