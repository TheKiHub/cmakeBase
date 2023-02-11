set(currentFolder ${CMAKE_CURRENT_LIST_DIR})

function(handleExternals)
    cmake_parse_arguments(HANDLE_EXTERNALS "" "NAME;VERSION" "" ${ARGN})

    # make sure we don't have too many arguments currently we can have the Name and Version with one value
    # can't be done if we get multiValueArgs
    if(${ARGC} GREATER 4 OR ${ARGC} LESS 2)
        message(ERROR "Wrong number of arguments. The form is: NAME <externalVersion> [optional]VERSION <specialVersion>")
    endif()

    # if target is already there return
    if(TARGET ${HANDLE_EXTERNALS_NAME})
        return()
    endif()

    message(DEBUG "Try to get external ${HANDLE_EXTERNALS_NAME}")

    file(GLOB files "${currentFolder}/externals/*")
    set(file_list)
    foreach(file ${files})
        get_filename_component(filename ${file} NAME_WE)
        list(APPEND file_list ${filename})
    endforeach()

    list(FIND file_list ${HANDLE_EXTERNALS_NAME} index)
    if(index GREATER -1)
        list(GET files ${index} dependencyFile)
        include(${dependencyFile})
        return()
    else()
        message(WARNING "Try to get external '${HANDLE_EXTERNALS_NAME}' which can't be found")
    endif()

endfunction()
