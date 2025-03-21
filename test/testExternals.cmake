#-------------------------------------------------------------------------------------------------------
# call every external and check if they are added
#-------------------------------------------------------------------------------------------------------
handleExternals(NAME doctest)
if(NOT TARGET doctest)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME freetype)
if(NOT TARGET freetype)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME glfw)
if(NOT TARGET glfw)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME google_benchmark)
if(NOT TARGET google_benchmark)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME hedley)
if(NOT TARGET hedley)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME imGui)
if(NOT TARGET imGui)
    message(FATAL_ERROR "External was not created")
endif()

if(${SIMPLIFIED_CPU_ARCH_TYPE} STREQUAL ("aarch64" OR "arm"))
    handleExternals(NAME mraa)
    if(NOT TARGET mraa)
        message(FATAL_ERROR "External was not created")
    endif()
endif()

handleExternals(NAME nlohmann_json)
if(NOT TARGET nlohmann_json)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME opengl)
if(NOT TARGET opengl)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME python)
if(NOT TARGET python)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME quill)
if(NOT TARGET quill)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME stbImage)
if(NOT TARGET stbImage)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME Taskflow)
if(NOT TARGET Taskflow)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME tomlplusplus_tomlplusplus)
if(NOT TARGET tomlplusplus_tomlplusplus)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME uWebSockets)
if(NOT TARGET uWebSockets)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME OpenSSL)
if(NOT TARGET OpenSSL)
    message(FATAL_ERROR "External was not created")
endif()

handleExternals(NAME googletest)
if(NOT (TARGET gtest_main AND TARGET gmock))
    message(FATAL_ERROR "External was not created")
endif()

#-------------------------------------------------------------------------------------------------------
# create a target which uses all externals to test compilation/linking
#-------------------------------------------------------------------------------------------------------
add_library(testExternal testExternal.cpp)
target_link_libraries(testExternal
            doctest
            freetype
            glfw
            google_benchmark
            hedley
            imGui
            libsecret
            mraa
            nlohmann_json
            opengl
            python
            quill
            refl-cpp
            stbImage
            Taskflow
            tomlplusplus_tomlplusplus
            uWebSockets
            gtest_main
            gmock
        )
set_target_cpp_compiler_flags(testExternal)
set_target_warnings(testExternal)
