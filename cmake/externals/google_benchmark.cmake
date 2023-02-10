# check if special Version is used or set the standard version
if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
    set(HANDLE_EXTERNALS_VERSION "1.7.1")
endif ()

CPMAddPackage(
        NAME benchmark
        GITHUB_REPOSITORY google/benchmark
        VERSION ${HANDLE_EXTERNALS_VERSION}
        OPTIONS
        "BENCHMARK_ENABLE_TESTING Off"
        "BENCHMARK_USE_LIBCXX ON"
)

if (benchmark_ADDED)
    # patch benchmark target
    set_target_properties(benchmark PROPERTIES CXX_STANDARD 17)
    message(DEBUG "benchmark ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "benchmark ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
