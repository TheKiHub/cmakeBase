#-------------------------------------------------------------------------------------------------------
# Depending on the compiler we do our best to choose the optimization flags
# Windows is not really supported, because it's not used by me and has its own weird behavior
#-------------------------------------------------------------------------------------------------------
macro(choose_optimization)
    if (CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        if (CMAKE_SYSTEM_PROCESSOR MATCHES “BCM28|armv7”)
            # we are on a raspberry pi like architecture
            set(CMAKE_CXX_FLAGS "-march=armv8-a+crc -mcpu=cortex-a53 -mfpu=neon-fp-armv8")
        else ()
            # processor unknown try out what can be used and set it
            _set_cpu_optimization()
            if (NOT ${ARCH} MATCHES “aarch64”)   #Advanced SIMD is mandatory for AArch64
                _check_neon()
            endif()
            _add_power_architecture_optimization()
        endif ()
        _set_optimization_flags()
    elseif (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        # for windows compiler just do the rudimentary optimization and use the cmake standard for optimization
        if (WIN32)
            set(CMAKE_CXX_FLAGS "/QxHost")
        else (WIN32)
            set(CMAKE_CXX_FLAGS "-xHost")
        endif ()
    endif ()
endmacro()

#-------------------------------------------------------------------------------------------------------
# If the arch type is not set,  it is set to "native" which let's the compiler try to find it out
# this is not guaranteed so if you know the hardware define the different strings in the cache
#-------------------------------------------------------------------------------------------------------
macro(_set_cpu_optimization)
    if(NOT DEFINED BASE_OPTIMIZATION_MARCH)
        set(BASE_OPTIMIZATION_MARCH "native" CACHE STRING "String which will be used for architecture instructions")
    endif()

    if(NOT DEFINED BASE_OPTIMIZATION_TUNE)
        set(BASE_OPTIMIZATION_TUNE "native" CACHE STRING "String which will be used for architecture optimization")
    endif()

    #-------------------------------------------------------------------------------------------------------
    # Check if the compiler supports the chosen optimization
    #-------------------------------------------------------------------------------------------------------
    include(CheckCXXCompilerFlag)
    check_cxx_compiler_flag("-march=${BASE_OPTIMIZATION_MARCH}" COMPILER_ARCH_SUPPORTED)
    if (COMPILER_ARCH_SUPPORTED)
        option(BASE_OPTIMIZATION_INSTRUCTIONS_FOR_ARCHITECTURE "Enable the usage of special instructions for the architecture, never use this with distributed compilers like distcc" ON)
    endif ()

    check_cxx_compiler_flag("-mtune=${BASE_OPTIMIZATION_TUNE}" COMPILER_TUNE_SUPPORTED)
    if (COMPILER_TUNE_SUPPORTED)
        option(BASE_OPTIMIZATION_TUNE_FOR_ARCHITECTURE "Enable architecture specific optimization, never use this with distributed compilers like distcc" ON)
    endif ()

    # Try -mcpu after march because it is deprecated on x86 and don't give an error if it does not work
    if (NOT COMPILER_ARCH_SUPPORTED)
        set(BASE_OPTIMIZATION_MCPU "native" CACHE STRING "String which will be used for native optimization")

        check_cxx_compiler_flag("-mcpu=${BASE_OPTIMIZATION_MCPU}" COMPILER_SUPPORTS_MCPU)
        if(COMPILER_SUPPORTS_MCPU)
            option(BASE_OPTIMIZATION_TARGET_ARCHITECTURE "Enable architecture specific optimization,never use this with distributed compilers like distcc" ON)
        endif()
    endif()

    #-------------------------------------------------------------------------------------------------------
    # Set the chosen flags
    #-------------------------------------------------------------------------------------------------------
    set(CMAKE_CXX_FLAGS "")

    if(BASE_OPTIMIZATION_INSTRUCTIONS_FOR_ARCHITECTURE)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -march=${BASE_OPTIMIZATION_MARCH}")
    endif()

    if(BASE_OPTIMIZATION_TUNE_FOR_ARCHITECTURE)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mtune=${BASE_OPTIMIZATION_TUNE}")
    endif()

    if(BASE_OPTIMIZATION_TARGET_ARCHITECTURE)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mcpu=${BASE_OPTIMIZATION_MCPU}")
    endif()
endmacro()

#-------------------------------------------------------------------------------------------------------
# Adds flags for Power architectures
#-------------------------------------------------------------------------------------------------------
macro(_add_power_architecture_optimization)
    include(CheckCXXCompilerFlag)
    check_cxx_compiler_flag("-maltivec -Werror" COMPILER_SUPPORTS_MALTIVEC)
    if(COMPILER_SUPPORTS_MALTIVEC)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -maltivec")
    endif()

    check_cxx_compiler_flag("-mabi=altivec -Werror" COMPILER_SUPPORTS_MABI_ALTIVEC)
    if(COMPILER_SUPPORTS_MABI_ALTIVEC)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mabi=altivec")
    endif()

    check_cxx_compiler_flag("-mvsx -Werror" COMPILER_SUPPORTS_MVSX)
    if(COMPILER_SUPPORTS_MVSX)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mvsx")
    endif()
endmacro()

#-------------------------------------------------------------------------------------------------------
# Checks if neon can be used, this is currently only available for gnu and clang compiler
#-------------------------------------------------------------------------------------------------------
macro(_check_neon)
    if(CMAKE_C_COMPILER_ID STREQUAL GNU OR MAKE_C_COMPILER_ID STREQUAL Clang)
        include(CheckCSourceCompiles)
        include(CheckIncludeFile)

        check_include_file(arm_neon.h HAS_NEON_HEADER)
        if(HAS_NEON_HEADER)
            if(CMAKE_C_COMPILER_ID STREQUAL GNU)
                set(CMAKE_REQUIRED_FLAGS -mcpu=native -mfpu=neon -ftree-vectorize)
            endif()
            check_c_source_compiles(
                    "#include \"arm_neon.h\"
                          int main(void){
                            float32x4_t test = { 0.0, 0.0, 0.0, 0.0 };
                            return 0;
                          }"
                    HAS_NEON
            )
            if(HAS_NEON)
                set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -mfpu=neon -ftree-vectorize -mfloat-abi=hard")
            endif()
        endif()
    endif()
endmacro()

#-------------------------------------------------------------------------------------------------------
# Sets the optimization flags for release
#-------------------------------------------------------------------------------------------------------
macro(_set_optimization_flags)
    option(BASE_OPTIMIZATION_OPTIMIZE_WITH_STANDARD_BREAK "Build with highest optimization but disregard strict
           IEEE or ISO rules, this can mean a loss of precision which can lead to incorrect output." OFF)

    if(BASE_OPTIMIZATION_OPTIMIZE_WITH_STANDARD_BREAK)
        message(NOTICE "The generated code will be optimized as much as possible, but the correct output is not guaranteed")
        set(CMAKE_CXX_FLAGS_RELEASE "-Ofast")
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-Ofast -g")
    else()
        set(CMAKE_CXX_FLAGS_RELEASE "-O3")
        set(CMAKE_CXX_FLAGS_RELWITHDEBINFO "-O3 -g")
    endif()

    # just to be sure the debug definition is still there after all the flag handling
    add_definitions(-DNDEBUG)
endmacro()
