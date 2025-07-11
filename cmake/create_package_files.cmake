#-------------------------------------------------------------------------------------------------------
# Create a custom target that only includes the necessary files for other repositories.
# This custom target can then be used to generate an archive that can be attached as an asset in each release.
# Automatically checks which files and directories exists
#-------------------------------------------------------------------------------------------------------

set(PACKAGE_SOURCE_DIR ${CMAKE_SOURCE_DIR})
set(PACKAGE_BINARY_DIR ${CMAKE_BINARY_DIR})
set(ZIP_OUTPUT ${PACKAGE_BINARY_DIR}/package_files.zip)

set(FETCH_PACKAGE_FILES
    ${PACKAGE_SOURCE_DIR}/CMakeLists.txt
)

if(EXISTS "${PACKAGE_SOURCE_DIR}/cmake")
    list(APPEND FETCH_PACKAGE_FILES "${PACKAGE_SOURCE_DIR}/cmake")
endif()

if(EXISTS "${PACKAGE_SOURCE_DIR}/libs")
    list(APPEND FETCH_PACKAGE_FILES "${PACKAGE_SOURCE_DIR}/libs")
endif()

if(EXISTS "${PACKAGE_SOURCE_DIR}/LICENSE")
    list(APPEND FETCH_PACKAGE_FILES "${PACKAGE_SOURCE_DIR}/LICENSE")
endif()

if(FETCH_PACKAGE_FILES)
    add_custom_command(
        OUTPUT ${ZIP_OUTPUT}
        COMMAND ${CMAKE_COMMAND} -E tar c ${ZIP_OUTPUT} --format=zip -- ${FETCH_PACKAGE_FILES}
        WORKING_DIRECTORY ${PACKAGE_SOURCE_DIR}
        DEPENDS ${FETCH_PACKAGE_FILES}
    )

    add_custom_target(create_package_files DEPENDS ${ZIP_OUTPUT})
else()
    message(WARNING "No files specified for FetchContent package. Please check the FETCH_PACKAGE_FILES variable")
endif()
