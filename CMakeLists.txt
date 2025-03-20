cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

if (${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_LIST_DIR})
    project(cmakeBase VERSION 0.5.0)
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
    set(CMAKE_CXX_STANDARD ${CXX_STANDARD} PARENT_SCOPE)
    set(CMAKE_CXX_STANDARD_REQUIRED ON PARENT_SCOPE)
    set(CMAKE_CXX_EXTENSIONS OFF PARENT_SCOPE)
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
set(CMAKE_DEBUG_POSTFIX d PARENT_SCOPE)
set(CMAKE_EXPORT_COMPILE_COMMANDS ON PARENT_SCOPE)   # Generate compile_commands.json for clang based tools

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
    if(WIN32)
        set(CPM_SOURCE_CACHE "$ENV{USERPROFILE}/.cache/CPM" CACHE STRING "CPM cache directory")
    else()
        set(CPM_SOURCE_CACHE "$ENV{HOME}/.cache/CPM" CACHE STRING "CPM cache directory")
    endif()
endif()
message(DEBUG "CPM will use the cache: ${CPM_SOURCE_CACHE}")
include(${CMAKE_CURRENT_LIST_DIR}/cmake/get_cpm.cmake)
set(CPM_USE_NAMED_CACHE_DIRECTORIES ON PARENT_SCOPE) # improve readability of packages names
include(${CMAKE_CURRENT_LIST_DIR}/cmake/handle_externals.cmake)

#-------------------------------------------------------------------------------------------------------
# Set output directories for binaries and libraries
#-------------------------------------------------------------------------------------------------------
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/bin PARENT_SCOPE)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib PARENT_SCOPE)
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/lib PARENT_SCOPE)

#-------------------------------------------------------------------------------------------------------
# Set default installation directories
#-------------------------------------------------------------------------------------------------------
if (CMAKE_INSTALL_PREFIX_INITIALIZED_TO_DEFAULT)
    set(CMAKE_INSTALL_PREFIX "${CMAKE_SOURCE_DIR}/install" CACHE PATH "Default install path" FORCE)
endif()

#-------------------------------------------------------------------------------------------------------
# RPATH handling
#-------------------------------------------------------------------------------------------------------
if (APPLE)
    set(CMAKE_MACOSX_RPATH ON PARENT_SCOPE)
endif ()

set(CMAKE_SKIP_BUILD_RPATH OFF PARENT_SCOPE) # Add absolute path to all dependencies
set(CMAKE_BUILD_WITH_INSTALL_RPATH OFF PARENT_SCOPE)
set(CMAKE_INSTALL_RPATH_USE_LINK_PATH OFF PARENT_SCOPE)

if (NOT SYSTEM_DIR_INSTALL)
    set(CMAKE_INSTALL_RPATH "${CMAKE_INSTALL_PREFIX}" PARENT_SCOPE)
endif ()

#-------------------------------------------------------------------------------------------------------
# Helper functions
#-------------------------------------------------------------------------------------------------------
include(${CMAKE_CURRENT_LIST_DIR}/cmake/compiler_warnings.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/faster_development.cmake)
include(${CMAKE_CURRENT_LIST_DIR}/cmake/create_package_files.cmake)
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.13.0") # used to make the targets installable
