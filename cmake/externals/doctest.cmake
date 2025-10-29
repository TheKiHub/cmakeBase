# https://github.com/doctest/doctest
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "2.4.12")
endif ()

# doctest using CMake 3.0 and gives errors about IPO so we turn it off and on after the target got created
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION_buffer ${CMAKE_INTERPROCEDURAL_OPTIMIZATION})
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION FALSE)
CPMAddPackage(
        NAME doctest
        GITHUB_REPOSITORY doctest/doctest
        VERSION ${HANDLE_EXTERNALS_VERSION}
)
set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ${CMAKE_INTERPROCEDURAL_OPTIMIZATION_buffer})

if (doctest_ADDED)
    set(${doctest_SOURCE_DIR} ${doctest_SOURCE_DIR} PARENT_SCOPE)
    message(DEBUG "doctest ${HANDLE_EXTERNALS_VERSION} created")
endif ()

if(NOT TARGET doctest)
    message(WARNING "doctest ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
