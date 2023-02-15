#-------------------------------------------------------------------------------------------------------
# Use this as root CMake to create some targets which tests the different cmake functions
#-------------------------------------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.16)
project(test LANGUAGES C CXX)
include(../CMakeLists.txt)

include(testExternalHandling.cmake)
