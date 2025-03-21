# https://github.com/google/benchmark
# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "1.9.1")
endif ()

#-------------------------------------------------------------------------------------------------------
# check if we have std::regex support
#-------------------------------------------------------------------------------------------------------
include(CMakePushCheckState)
include(CheckCXXSourceRuns)
cmake_push_check_state()
set(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} -std=c++11")
check_cxx_source_runs("
      #include <regex>

      int main() {
        return std::regex_match(\"StackOverflow\", std::regex(\"(stack)(.*)\"));
      }
" HAVE_CXX_11_REGEX)
cmake_pop_check_state()

CPMAddPackage(
        NAME benchmark
        GITHUB_REPOSITORY google/benchmark
        VERSION ${HANDLE_EXTERNALS_VERSION}
        OPTIONS
        "BENCHMARK_ENABLE_TESTING Off"
        "HAVE_STD_REGEX ${HAVE_CXX_11_REGEX}"
)

if (benchmark_ADDED)
    # patch benchmark target
    add_library(google_benchmark ALIAS benchmark)
    message(DEBUG "google_benchmark ${HANDLE_EXTERNALS_VERSION} created")
endif()

if(NOT TARGET google_benchmark)
    message(WARNING "google_benchmark ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
