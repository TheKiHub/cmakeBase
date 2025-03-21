# warnings and tips about them came from here:
# https://github.com/lefticus/cppbestpractices/blob/master/02-Use_the_Tools_Available.md

function(inhibit_target_warnings TARGET_NAME)
    get_target_property(TARGET_TYPE ${TARGET_NAME} TYPE)
    if(TARGET_TYPE STREQUAL "INTERFACE_LIBRARY" OR TARGET_TYPE STREQUAL "UTILITY" OR TARGET_TYPE STREQUAL "IMPORTED")
        # Not issuing a warning because 'inhibit_target_warnings' is also used to silence external warnings.
        # This may be called for imported system targets, where warnings should not be reported.
        message(STATUS "Skipping warning inhibition for ${TARGET_TYPE} target '${TARGET_NAME}'")
        return()
    endif()
    if (CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        target_compile_options(${TARGET_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:-w> $<$<COMPILE_LANGUAGE:C>:-w>)
    elseif (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        # For Microsoft compilers (MSVC), we must remove existing warning flags 
        # (e.g., /W1, /W2, /W3, /W4, /Wall) before adding /w. 
        # This prevents the D9025 warning: "overriding '/Wx' with '/w'".
        
        # Retrieve existing compile options
        get_target_property(COMPILE_OPTIONS ${TARGET_NAME} COMPILE_OPTIONS)
        if (NOT COMPILE_OPTIONS)
            set(COMPILE_OPTIONS "")  # Ensure it's defined
        endif()

        # Remove existing warning level flags (/W1, /W2, /W3, /W4, /Wall)
        foreach(WARNING_FLAG /W0 /W1 /W2 /W3 /W4 /Wall /WX -Wall)
            string(REPLACE ${WARNING_FLAG} "" COMPILE_OPTIONS "${COMPILE_OPTIONS}")
        endforeach()

        # Apply the desired warning flag (e.g., /w to suppress all warnings)
        set_target_properties(${TARGET_NAME} PROPERTIES COMPILE_OPTIONS "")
        target_compile_options(${TARGET_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${COMPILE_OPTIONS} /w> $<$<COMPILE_LANGUAGE:C>:${COMPILE_OPTIONS} /w>)
    endif ()
endfunction ()


function(set_target_warnings TARGET_NAME)
    get_target_property(TARGET_TYPE ${TARGET_NAME} TYPE)
    if(TARGET_TYPE STREQUAL "INTERFACE_LIBRARY" OR TARGET_TYPE STREQUAL "UTILITY" OR TARGET_TYPE STREQUAL "IMPORTED")
        message(WARNING "Can't inhibit warnings for INTERFACE_LIBRARY target '${TARGET_NAME}' because it changes the behavior of all targets that use this target")
        return()
    endif()
    option(WARNINGS_AS_ERRORS "Treat compiler warnings as errors" FALSE)

    if (CMAKE_CXX_COMPILER_ID MATCHES "GNU" OR CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        set(PROJECT_WARNINGS
                -Wall
                -Wextra # reasonable and standard
                -Wextra-semi # Warn about semicolon after in-class function definition.
                -Wshadow # warn the user if a variable declaration shadows one from a parent context
                -Wnon-virtual-dtor # warn the user if a class with virtual functions has a non-virtual destructor. This helps
                # catch hard to track down memory errors
                -Wold-style-cast # warn for c-style casts
                -Wcast-align # warn for potential performance problem casts
                -Wunused # warn on anything being unused
                -Woverloaded-virtual # warn if you overload (not override) a virtual function
                -Wpedantic # warn if non-standard C++ is used
                -Wconversion # warn on type conversions that may lose data
                -Wsign-conversion # warn on sign conversions
                -Wnull-dereference # warn if a null dereference is detected
                -Wdouble-promotion # warn if float is implicit promoted to double
                -Wformat=2 # warn on security issues around functions that format output (ie printf)
                -Wimplicit-fallthrough # warn on statements that fallthrough without an explicit annotation
                )
        if (WARNINGS_AS_ERRORS)
            list(APPEND PROJECT_WARNINGS -Werror)
        endif ()
        if (CMAKE_CXX_COMPILER_ID MATCHES "GNU")
            list(APPEND PROJECT_WARNINGS
                    -Wmisleading-indentation # warn if indentation implies blocks where blocks do not exist
                    -Wduplicated-cond # warn if if / else chain has duplicated conditions
                    -Wduplicated-branches # warn if if / else branches have duplicated code
                    -Wlogical-op # warn about logical operations being used where bitwise were probably wanted
                    -Wuseless-cast # warn if you perform a cast to the same type
                    )
        endif ()
    elseif (CMAKE_CXX_COMPILER_ID MATCHES "MSVC")
        set(PROJECT_WARNINGS
                /W4 # Baseline reasonable warnings
                /w14242 # 'identifier': conversion from 'type1' to 'type1', possible loss of data
                /w14254 # 'operator': conversion from 'type1:field_bits' to 'type2:field_bits', possible loss of data
                /w14263 # 'function': member function does not override any base class virtual member function
                /w14265 # 'classname': class has virtual functions, but destructor is not virtual instances of this class may not
                # be destructed correctly
                /w14287 # 'operator': unsigned/negative constant mismatch
                /we4289 # nonstandard extension used: 'variable': loop control variable declared in the for-loop is used outside
                # the for-loop scope
                /w14296 # 'operator': expression is always 'boolean_value'
                /w14311 # 'variable': pointer truncation from 'type1' to 'type2'
                /w14545 # expression before comma evaluates to a function which is missing an argument list
                /w14546 # function call before comma missing argument list
                /w14547 # 'operator': operator before comma has no effect; expected operator with side-effect
                /w14549 # 'operator': operator before comma has no effect; did you intend 'operator'?
                /w14555 # expression has no effect; expected expression with side- effect
                /w14619 # pragma warning: there is no warning number 'number'
                /w14640 # Enable warning on thread un-safe static member initialization
                /w14826 # Conversion from 'type1' to 'type_2' is sign-extended. This may cause unexpected runtime behavior.
                /w14905 # wide string literal cast to 'LPSTR'
                /w14906 # string literal cast to 'LPWSTR'
                /w14928 # illegal copy-initialization; more than one user-defined conversion has been implicitly applied
                /permissive- # standards conformance mode for MSVC compiler.
                )
        if (WARNINGS_AS_ERRORS)
            list(APPEND PROJECT_WARNINGS /WX)
        endif ()
    else ()
        message(DEBUG "No compiler warnings set for '${CMAKE_CXX_COMPILER_ID}' compiler.")
    endif ()

    message(DEBUG "Set warning flags for '${TARGET_NAME}' to ${PROJECT_WARNINGS}")
    target_compile_options(${TARGET_NAME} PRIVATE $<$<COMPILE_LANGUAGE:CXX>:${PROJECT_WARNINGS}>)
endfunction()
