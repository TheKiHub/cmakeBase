#-------------------------------------------------------------------------------------------------------
# Create a custom target that only includes the necessary files for other repositories.
# This custom target can then be used to generate an archive that can be attached as an asset in each release.
# Automatically checks which files and directories exists
#-------------------------------------------------------------------------------------------------------

if(NOT DEFINED FETCH_PACKAGE_FILES)
     set(FETCH_PACKAGE_FILES CMakeLists.txt) # without root CMake there is nothing to fetch

     if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/cmake")
         set(FETCH_PACKAGE_FILES ${FETCH_PACKAGE_FILES} cmake)
     endif()

     if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/libs")
         set(FETCH_PACKAGE_FILES ${FETCH_PACKAGE_FILES} libs)
     endif()

     if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/LICENSE")
         set(FETCH_PACKAGE_FILES ${FETCH_PACKAGE_FILES} LICENSE)
     endif()
endif()

 add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/package_files.zip
         COMMAND ${CMAKE_COMMAND} -E tar c ${CMAKE_CURRENT_BINARY_DIR}/package_files.zip --format=zip -- ${FETCH_PACKAGE_FILES}
         WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
         DEPENDS ${FETCH_PACKAGE_FILES})
 add_custom_target(create_package_files DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/package_files.zip)
