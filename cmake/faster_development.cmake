#-------------------------------------------------------------------------------------------------------
# Optional Speedups
#-------------------------------------------------------------------------------------------------------
option(BASE_SETTINGS_ENABLE_IPO "Enable Interprocedural Optimization, aka Link Time Optimization (LTO)" ON)
if (BASE_SETTINGS_ENABLE_IPO)
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result OUTPUT output)
    if (result)
        set(CMAKE_INTERPROCEDURAL_OPTIMIZATION ON)
        set(CMAKE_POLICY_DEFAULT_CMP0069 NEW)
    else ()
        message(WARNING "IPO is enabled but not supported: ${output}")
    endif ()
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
            message(STATUS "Set linker to LLD (multi-threaded): ${LLD_PROGRAM_MATCH_VER}")
            add_link_options("-fuse-ld=lld-${CLANG_VERSION_MAJOR}")
        else()
            find_program(LLD_PROGRAM lld) #else find default lld
            if(LLD_PROGRAM) #default lld
                message(STATUS "Set linker to LLD (multi-threaded): ${LLD_PROGRAM}")
                add_link_options("-fuse-ld=lld")
            endif()
        endif()
    elseif(${CMAKE_CXX_COMPILER_ID} MATCHES GNU)
        find_program(GNU_GOLD_PROGRAM gold)
        if (GNU_GOLD_PROGRAM)
            message(STATUS "Set linker to GNU gold: ${GNU_GOLD_PROGRAM}, using threads: ${HOST_PROC_COUNT}")
            add_link_options("-fuse-ld=gold;LINKER:--threads,--thread-count=${HOST_PROC_COUNT}")
        else()
            message(WARNING "To enable the faster gold linker for GCC, consider installing 'binutils'. Note that you can disable this message by setting the option USE_LD_GOLD to OFF")
        endif()
    endif()
endif()
