#-------------------------------------------------------------------------------------------------------
# Optional Speedups
#-------------------------------------------------------------------------------------------------------
include(CheckIPOSupported)
check_ipo_supported(RESULT result OUTPUT output)
if (result)
    option(BASE_SETTINGS_ENABLE_IPO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)" ON)
    if(BASE_SETTINGS_ENABLE_IPO)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
        set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)
        message(STATUS "Using Interprocedural Optimization (LTO)")
    endif()
else ()
    message(DEBUG "IPO is not supported: ${output}")
endif ()

CPMAddPackage(
        NAME Ccache.cmake
        GITHUB_REPOSITORY TheLartians/Ccache.cmake
        VERSION 1.2.4
)

if (UNIX AND NOT APPLE)
    include(ProcessorCount)
    ProcessorCount(HOST_PROC_COUNT)

    if(${CMAKE_CXX_COMPILER_ID} MATCHES Clang)
        string(REPLACE "." ";" VERSION_LIST ${CMAKE_CXX_COMPILER_VERSION})
        list(GET VERSION_LIST 0 CLANG_VERSION_MAJOR) #extract major compiler version

        find_program(LLD_PROGRAM_MATCH_VER lld-${CLANG_VERSION_MAJOR}) #search for lld-13 when clang 13.x.x is used
        if (LLD_PROGRAM_MATCH_VER) #lld matching compiler version
            option(USE_LDD_LINKER "The ldd linker will be used instead of the default linker" ON)
            if(USE_LDD_LINKER)
                message(STATUS "Set linker to LLD (multi-threaded): ${LLD_PROGRAM_MATCH_VER}")
                add_link_options("-fuse-ld=lld-${CLANG_VERSION_MAJOR}")
            endif()
        else()
            find_program(LLD_PROGRAM lld) #else find default lld
            if(LLD_PROGRAM) #default lld
                option(USE_LDD_LINKER "The ldd linker will be used instead of the default linker" ON)
                if(USE_LDD_LINKER)
                    message(STATUS "Set linker to LLD (multi-threaded): ${LLD_PROGRAM}")
                    add_link_options("-fuse-ld=lld")
                endif()
            endif()
        endif()
    elseif(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
        find_program(GNU_GOLD_PROGRAM gold)
        if (GNU_GOLD_PROGRAM)
            # golden linker got problems on many aarch64 platforms so we deactivate it per default even if he's available
            if (NOT "${ARCH}" STREQUAL "aarch64")
                option(USE_GOLD_LINKER "The gnu gold linker will be used instead of the default linker" ON)
            else ()
                option(USE_GOLD_LINKER "The gnu gold linker will be used instead of the default linker" OFF)
            endif ()
            if(USE_GOLD_LINKER)
                MATH(EXPR PROS_COUNT ${HOST_PROC_COUNT}/2)
                message(STATUS "Set linker to GNU gold: ${GNU_GOLD_PROGRAM}, using threads: ${PROS_COUNT}")
                add_link_options("-fuse-ld=gold;LINKER:--threads,--thread-count=${PROS_COUNT}")
                unset(PROS_COUNT)
            endif()
        endif()
    endif()
endif()
