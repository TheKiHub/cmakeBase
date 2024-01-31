cmake_minimum_required(VERSION 3.16...3.26 FATAL_ERROR)

if (${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_LIST_DIR})
    project(cmakeBase VERSION 0.3.2)
endif ()

#-------------------------------------------------------------------------------------------------------
# Set the c++ standard which should be used based on what is supported
#-------------------------------------------------------------------------------------------------------
if ("cxx_std_20" IN_LIST CMAKE_CXX_COMPILE_FEATURES)
    set(CXX_STANDARD 20)
elseif ("cxx_std_17" IN_LIST CMAKE_CXX_COMPILE_FEATURES)
    set(CXX_STANDARD 17)
elseif ("cxx_std_14" IN_LIST CMAKE_CXX_COMPILE_FEATURES)
    set(CXX_STANDARD 14)
elseif ("cxx_std_11" IN_LIST CMAKE_CXX_COMPILE_FEATURES)
    set(CXX_STANDARD 11)
endif ()

if (DEFINED CXX_STANDARD)
    set(CMAKE_CXX_STANDARD ${CXX_STANDARD})
    set(CMAKE_CXX_STANDARD_REQUIRED ON)
    set(CMAKE_CXX_EXTENSIONS OFF)
    message(STATUS "Configuring C++ standard: ${CXX_STANDARD}")
endif ()

#-------------------------------------------------------------------------------------------------------
# Disable in-source builds to prevent source tree corruption
#-------------------------------------------------------------------------------------------------------
if ("${CMAKE_SOURCE_DIR}" STREQUAL "${CMAKE_BINARY_DIR}")
    message(FATAL_ERROR "In-source builds are not allowed. You must create a separate directory for build files.")
endif ()

#-------------------------------------------------------------------------------------------------------
# Set a default build type if none was specified
#-------------------------------------------------------------------------------------------------------
if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
    message(STATUS "No build type specified; defaulting to 'RelWithDebInfo'.")
    set(CMAKE_BUILD_TYPE "RelWithDebInfo" CACHE STRING "Choose the type of build.")
    set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
            "Debug"
            "Release"
            "MinSizeRel"
            "RelWithDebInfo")
endif()

#-------------------------------------------------------------------------------------------------------
# Set some standard Flags and allow usage of newest policies possible
#-------------------------------------------------------------------------------------------------------
cmake_policy(VERSION ${CMAKE_MAJOR_VERSION}.${CMAKE_MINOR_VERSION})
set(CMAKE_DEBUG_POSTFIX d)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON)   # Generate compile_commands.json for clang based tools

#-------------------------------------------------------------------------------------------------------
# Set the Arch variable to the current architecture for easier usage
#-------------------------------------------------------------------------------------------------------
include(${CMAKE_CURRENT_LIST_DIR}/cmake/get_arch_type.cmake)

#-------------------------------------------------------------------------------------------------------
# Optimization flag handling
#-------------------------------------------------------------------------------------------------------
include(${CMAKE_CURRENT_LIST_DIR}/cmake/optimization_flags.cmake)
choose_optimization()

#-------------------------------------------------------------------------------------------------------
# External handling
#-------------------------------------------------------------------------------------------------------
# if no specific Cache is set, set same CPM cache for every project
if (NOT CPM_SOURCE_CACHE)
    set(CPM_SOURCE_CACHE "$ENV{HOME}/.cache/CPM")
endif()
message(DEBUG "CPM will use the cache: ${CPM_SOURCE_CACHE}")
include(${CMAKE_CURRENT_LIST_DIR}/cmake/get_cpm.cmake)
set(CPM_USE_NAMED_CACHE_DIRECTORIES ON) # improve readability of packages names
include(${CMAKE_CURRENT_LIST_DIR}/cmake/handle_externals.cmake)

#-------------------------------------------------------------------------------------------------------
# RPATH handling
#-------------------------------------------------------------------------------------------------------
if (APPLE)
    set(CMAKE_MACOSX_RPATH ON)
endif ()

set(CMAKE_SKIP_BUILD_RPATH OFF) # Add absolute path to all dependencies
set(CMAKE_BUILD_WITH_INSTALL_RPATH OFF)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH OFF)

if (NOT SYSTEM_DIR_INSTALL)
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}")
endif ()

#-------------------------------------------------------------------------------------------------------
# Helper functions
#-------------------------------------------------------------------------------------------------------
include(${CMAKE_CURRENT_LIST_DIR}/cmake/compiler_warnings.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/faster_development.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/create_package_files.cmake)
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.11.0") # used to make the targets installable

#-------------------------------------------------------------------------------------------------------
# Only include tests if this repo is not fetched and used by another repo
#-------------------------------------------------------------------------------------------------------
if(EXISTS test)
    set(CMAKE_BASE_TESTS CACHE BOOL OFF)
    if(CMAKE_BASE_TESTS)
        add_subdirectory(test)
    endif()
endif()
