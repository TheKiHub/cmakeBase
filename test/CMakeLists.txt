cmake_minimum_required(VERSION 3.16 FATAL_ERROR)

project(testCmakeBase)

# Simulate fetch behavior  
# FetchContent_MakeAvailable() internally uses add_subdirectory(),  
# so we manually add the parent directory in a similar way.  
add_subdirectory(${CMAKE_CURRENT_LIST_DIR}/.. CmakeBase)

# Include test scripts
include(${CMAKE_CURRENT_LIST_DIR}/testExternals.cmake)
