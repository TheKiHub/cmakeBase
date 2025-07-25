# https://github.com/nlohmann/json
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "3.12.0")
endif ()

CPMAddPackage(
        NAME nlohmann_json
        VERSION ${HANDLE_EXTERNALS_VERSION}
        # the git repo is incredibly large, so we download the archived include directory
        URL https://github.com/nlohmann/json/releases/download/v${HANDLE_EXTERNALS_VERSION}/include.zip
)


if (nlohmann_json_ADDED)
    add_library(nlohmann_json INTERFACE IMPORTED)
    target_include_directories(nlohmann_json SYSTEM INTERFACE
            $<BUILD_INTERFACE:${nlohmann_json_SOURCE_DIR}/include>
            $<INSTALL_INTERFACE:include>)
    if ("cxx_std_17" IN_LIST CMAKE_CXX_COMPILE_FEATURES)
        option(NLOHMANN_JSON_CXX17_FEATURES "Activate the C++17 features in the nlohmann_json library" ON)
        if(NLOHMANN_JSON_CXX17_FEATURES)
            target_compile_definitions(nlohmann_json INTERFACE JSON_HAS_CPP_17)
            message(DEBUG "nlohmann_json ${HANDLE_EXTERNALS_VERSION} with activated c++17 features created")
        endif ()
    else ()
        message(DEBUG "nlohmann_json ${HANDLE_EXTERNALS_VERSION} created")
    endif ()
endif()

if(NOT TARGET nlohmann_json)
    message(WARNING "nlohmann_json ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
