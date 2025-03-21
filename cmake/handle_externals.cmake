# The following block is intended to create the list of external files only once, 
# avoiding recreating it every time the function is called.
file(GLOB ALL_EXTERNAL_FILES "${CMAKE_CURRENT_LIST_DIR}/externals/*")
set(file_list)
foreach(file ${ALL_EXTERNAL_FILES})
    get_filename_component(filename ${file} NAME_WE)
    list(APPEND file_list ${filename})
endforeach()
# Store the list in the parent scope so it's accessible inside functions
set(file_list ${file_list} CACHE INTERNAL "List of all external names")
set(ALL_EXTERNAL_FILES ${ALL_EXTERNAL_FILES} CACHE INTERNAL "List of external files")

# Global variable to store information about external dependencies
set(external_dependency_versions_and_sources "" CACHE INTERNAL "List of dependency and versions")

macro(include_as_systemheaders target)
    get_target_property(existing_includes ${target} INTERFACE_INCLUDE_DIRECTORIES)

    if (existing_includes)
        set(filtered_includes "")

        foreach(dir ${existing_includes})
            if (NOT dir MATCHES "^${CMAKE_SOURCE_DIR}.*")  # Exclude source directory paths
                list(APPEND filtered_includes ${dir})
            endif()
        endforeach()

        if (filtered_includes)
            target_include_directories(${target} SYSTEM INTERFACE ${filtered_includes})
        endif()
    endif()
endmacro()

function(handleExternals)
    cmake_parse_arguments(HANDLE_EXTERNALS "" "NAME;VERSION" "" ${ARGN})

    # make sure we don't have too many arguments currently we can have the Name and Version with one value
    # can't be done if we get multiValueArgs
    if(${ARGC} GREATER 4 OR ${ARGC} LESS 2)
        message(FATAL_ERROR "Wrong number of arguments. The form is: NAME <externalVersion> [optional]VERSION <specialVersion>")
    endif()

    message(DEBUG "Try to get external ${HANDLE_EXTERNALS_NAME}")
    # Check if the external dependency with the same name and different version has already been processed
    foreach(entry IN LISTS external_dependency_versions_and_sources)
        string(REGEX MATCH "([^_]+)_?(.*)_(.*)" match_result ${entry})

        if(match_result)
            set(entry_NAME ${CMAKE_MATCH_1})
            set(entry_VERSION ${CMAKE_MATCH_2})
            set(entry_SOURCE_FILE ${CMAKE_MATCH_3})

            if(${entry_NAME} STREQUAL ${HANDLE_EXTERNALS_NAME})
                # External dependency with the same name found, compare versions
                if(NOT "${HANDLE_EXTERNALS_VERSION}" STREQUAL "${entry_VERSION}")
                    if("${entry_VERSION}" STREQUAL "")
                        set(entry_VERSION "default")
                    endif()
                    if("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
                        set(HANDLE_EXTERNALS_VERSION "default")
                    endif()
                    message(WARNING "External '${HANDLE_EXTERNALS_NAME}' already exists with version ${entry_VERSION} it was created by ${entry_SOURCE_FILE}. Requested version '${HANDLE_EXTERNALS_VERSION}' is overridden.")
                    return()
                else()
                    # External dependency with the same name and version has already been processed, return
                    return()
                endif()
            endif()
        endif()
    endforeach()

    list(FIND file_list ${HANDLE_EXTERNALS_NAME} index)
    if(index GREATER -1)
        # Store information about the processed external dependency
        list(APPEND external_dependency_versions_and_sources "${HANDLE_EXTERNALS_NAME}_${HANDLE_EXTERNALS_VERSION}_${CMAKE_CURRENT_LIST_FILE}")
        set(external_dependency_versions_and_sources ${external_dependency_versions_and_sources} PARENT_SCOPE)
        
        list(GET ALL_EXTERNAL_FILES ${index} dependencyFile)
        include(${dependencyFile})
        return()
    else()
        message(WARNING "Try to get external '${HANDLE_EXTERNALS_NAME}' which can't be found")
    endif()
endfunction()
