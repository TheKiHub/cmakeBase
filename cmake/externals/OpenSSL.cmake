# Find OpenSSL if it's already installed
find_package(OpenSSL QUIET)

# If OpenSSL is not found, download and build it as an external project
if(NOT OpenSSL_FOUND)
    if ("${HANDLE_EXTERNALS_VERSION}" STREQUAL "")
        set(HANDLE_EXTERNALS_VERSION "3.2.1")
    endif ()

    include(ExternalProject)
    ExternalProject_Add(
            openssl
            URL https://www.openssl.org/source/openssl-${HANDLE_EXTERNALS_VERSION}.tar.gz
            CONFIGURE_COMMAND ./config --prefix=${CMAKE_CURRENT_BINARY_DIR}/openssl
            BUILD_COMMAND make
            INSTALL_COMMAND make install
            PREFIX ${CMAKE_CURRENT_BINARY_DIR}/openssl
    )
    set(OPENSSL_ROOT_DIR "${CMAKE_CURRENT_BINARY_DIR}/openssl")
    find_package(OpenSSL REQUIRED)
endif()

if (OPENSSL_FOUND)
    # patch OpenSSL target
    if(NOT TARGET OpenSSL)
        add_library(OpenSSL ALIAS OpenSSL::SSL)
    endif()

    message(DEBUG "OpenSSL ${HANDLE_EXTERNALS_VERSION} created")
else ()
    message(WARNING "OpenSSL ${HANDLE_EXTERNALS_VERSION} could not be created")
endif ()
