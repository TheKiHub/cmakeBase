#needs to be set here or CMAKE_CURRENT_LIST_DIR will point to the current folder where the function is called
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

    if(${HANDLE_EXTERNALS_NAME} STREQUAL Taskflow)
        include(${currentFolder}/externals/taskflow.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL opengl)
        include(${currentFolder}/externals/opengl.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL glad)
        include(${currentFolder}/externals/glad.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL doctest)
        include(${currentFolder}/externals/doctest.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL refl-cpp)
        include(${currentFolder}/externals/refl-cpp.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL nlohmann_json)
        include(${currentFolder}/externals/nlohmann_json.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL tomlplusplus_tomlplusplus)
        include(${currentFolder}/externals/tomlplusplus_tomlplusplus.cmake)
        return()
    endif()


    if(${HANDLE_EXTERNALS_NAME} STREQUAL glfw)
        include(${currentFolder}/externals/glfw.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL google_benchmark)
        include(${currentFolder}/externals/google_benchmark.cmake)
        return()
    endif()


    if(${HANDLE_EXTERNALS_NAME} STREQUAL hedley)
        include(${currentFolder}/externals/hedley.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL freetype)
        include(${currentFolder}/externals/freetype.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL uwebsockets)
        include(${currentFolder}/externals/u_web_sockets.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL quill)
        include(${currentFolder}/externals/quill.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL python)
        include(${currentFolder}/externals/python.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL libsecret)
        include(${currentFolder}/externals/libsecret/FindLibsecret.cmake)
        include(${currentFolder}/externals/libsecret/libsecret.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL imGui)
        include(${currentFolder}/externals/imgui.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL imGuiNodeEditor)
        include(${currentFolder}/externals/imGuiNodeEditor.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL stbImage)
        include(${currentFolder}/externals/stbImage.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL mraa)
        include(${currentFolder}/externals/mraa.cmake)
        return()
    endif()

    if(${HANDLE_EXTERNALS_NAME} STREQUAL uWebSockets)
        include(${currentFolder}/externals/uWebSockets.cmake)
        return()
    endif()

    message(FATAL_ERROR "External ${HANDLE_EXTERNALS_NAME} was given which does not exist")
endfunction()
