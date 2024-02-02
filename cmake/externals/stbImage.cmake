project(stbImage VERSION 2.29)

file(DOWNLOAD https://raw.githubusercontent.com/nothings/stb/master/stb_image.h ${CMAKE_CURRENT_BINARY_DIR}/stbImage/stb_image.h)
add_library(stbImage INTERFACE)

# make the headers system, targets which include it should not get warnings
target_include_directories(stbImage
        SYSTEM INTERFACE
        $<INSTALL_INTERFACE:include/stbImage>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}/stbImage/>
        )

packageProject(
        NAME ${PROJECT_NAME}
        VERSION ${PROJECT_VERSION}
        BINARY_DIR ${PROJECT_BINARY_DIR}
        COMPATIBILITY SameMajorVersion
)

if (TARGET stbImage)
    message(DEBUG "stbImage created")
else ()
    message(WARNING "stbImage could not be created")
endif ()
