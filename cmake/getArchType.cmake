if(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86_64")
    set(ARCH "x86_64")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "amd64")
    set(ARCH "x86_64")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "AMD64")
    # cmake reports AMD64 on Windows, but we might be building for 32-bit.
    if(CMAKE_SIZEOF_VOID_P EQUAL 8)
        set(ARCH "x86_64")
    else()
        set(ARCH "x86")
    endif()
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "x86")
    set(ARCH "x86")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "i386")
    set(ARCH "x86")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "i686")
    set(ARCH "x86")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "aarch64")
    set(ARCH "aarch64")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "ARM64")
    set(ARCH "aarch64")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64")
    set(ARCH "aarch64")
    # Apple A12 Bionic chipset which is added in iPhone XS/XS Max/XR uses arm64e architecture.
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "arm64e")
    set(ARCH "aarch64")
elseif(CMAKE_SYSTEM_PROCESSOR MATCHES "^arm*")
    set(ARCH "arm")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "mips")
    # Just to avoid the “unknown processor” error.
    set(ARCH "generic")
elseif(CMAKE_SYSTEM_PROCESSOR STREQUAL "ppc64le")
    set(ARCH "ppc64le")
else()
    message(FATAL_ERROR "Unknown processor:" ${CMAKE_SYSTEM_PROCESSOR})
endif()