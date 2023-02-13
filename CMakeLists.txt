cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

if (${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_CURRENT_LIST_DIR})
    project(cmakeBase)
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
    message(STATUS "Setting build type to 'RelWithDebInfo' as none was specified.")
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
include(${CMAKE_CURRENT_LIST_DIR}/cmake/getArchType.cmake)

#-------------------------------------------------------------------------------------------------------
# Optimization flag handling
#-------------------------------------------------------------------------------------------------------
include(${CMAKE_CURRENT_LIST_DIR}/cmake/optimizationFlags.cmake)
choose_optimization()
message(DEBUG "Chosen CMAKE_CXX_FLAGS: ${CMAKE_CXX_FLAGS}")

#-------------------------------------------------------------------------------------------------------
# External handling
#-------------------------------------------------------------------------------------------------------
# if no specific Cache is set, set same CPM cache for every project
if (NOT DEFINED ${CPM_SOURCE_CACHE})
    set(CPM_SOURCE_CACHE $ENV{HOME}/.cache/CPM)
endif ()
include(${CMAKE_CURRENT_LIST_DIR}/cmake/get_cpm.cmake)
set(CPM_USE_NAMED_CACHE_DIRECTORIES ON) # improve readability of packages names in CLion
include(${CMAKE_CURRENT_LIST_DIR}/cmake/handleExternals.cmake)

#-------------------------------------------------------------------------------------------------------
# Helper functions
#-------------------------------------------------------------------------------------------------------
include(${CMAKE_CURRENT_LIST_DIR}/cmake/compilerWarnings.cmake)
CPMAddPackage("gh:TheLartians/PackageProject.cmake@1.10.0") # used to make the targets installable

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
# Optional Speedups
#-------------------------------------------------------------------------------------------------------
option(BASE_SETTINGS_ENABLE_IPO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)" ON)
if (BASE_SETTINGS_ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result OUTPUT output)
    if (result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION TRUE)
        if (CMAKE_POLICY_DEFAULT_CMP0069)
            cmake_policy(SET CMP0069 NEW)
        endif()
    else ()
        message(WARNING "IPO is enabled but not supported: ${output}")
    endif ()
endif ()

CPMAddPackage(
        NAME Ccache.cmake
        GITHUB_REPOSITORY TheLartians/Ccache.cmake
        VERSION 1.2.4
)

#-------------------------------------------------------------------------------------------------------
# Create a custom target that only includes the necessary files for other repositories
#-------------------------------------------------------------------------------------------------------
include(${CMAKE_CURRENT_LIST_DIR}/cmake/createPackageFiles.cmake)
