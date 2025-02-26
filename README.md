# cmakeBase


[![MAC build](https://github.com/TheKiHub/cmakeBase/actions/workflows/mac.yml/badge.svg)](https://github.com/TheKiHub/cmakeBase/actions/workflows/mac.yml)
[![Linux build](https://github.com/TheKiHub/cmakeBase/actions/workflows/linux.yml/badge.svg)](https://github.com/TheKiHub/cmakeBase/actions/workflows/linux.yml)
[![Windows build](https://github.com/TheKiHub/cmakeBase/actions/workflows/windows.yml/badge.svg)](https://github.com/TheKiHub/cmakeBase/actions/workflows/windows.yml)


---
This repository serves as the central hub for all my other repositories. For more information on how I structure 
my projects, please refer to the [Project Structure document](doku/ProjectStructure.md).

In short, the primary objective of this repository is to provide a common foundation for all my projects and make 
it possible to quickly distribute updates to the CMakeLists file, such as new library versions or compiler 
flags, across all repositories at once.

## Usage
This repository has been [optimized for fetching](doku/FetchOptimization.md)  and can be utilized by adding the 
following code to your CMakeLists.txt file:
```cmake
if(POLICY CMP0135)
    cmake_policy(SET CMP0135 NEW) # set fetch timestamp behavior to new policy
endif()
include(FetchContent)
FetchContent_Declare(
        cmakeBase
        URL https://github.com/TheKiHub/cmakeBase/releases/latest/download/package_files.zip
        SOURCE_DIR cmakeBase
)
FetchContent_MakeAvailable(cmakeBase)
 ```
