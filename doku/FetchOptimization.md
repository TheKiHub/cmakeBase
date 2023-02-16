# How to prepare a repository for CMake FetchContent

A more efficient approach to fetching a repository is to use releases instead of directly downloading the source code. 
Releases allow for a faster download as they only include the necessary files required to build and compile the 
repository. This is particularly beneficial when the repository is large and contains a lot of files that are not 
needed for the intended purpose, such as tests or data. The goal is to have a specific archive that only contains the 
essential files required to build the repository, reducing the amount of unnecessary data being transferred and 
saving bandwidth.

## Prepare the repository
It is important that when we retrieve the repository from an external source, 
the root CMakeLists file only includes the essential files.
This can be done by checking ```if (CMAKE_PROJECT_NAME STREQUAL PROJECT_NAME)```. If the
condition is met, then we include the files that we don't want to fetch, such as tests, etc.

Once we have set up our CMake properly, we can use a custom command to package the necessary files into an archive. 
To accomplish this, we create a CMake target that is specifically designed to trigger the custom command.
```cmake
set(FETCH_PACKAGE_FILES cmake/ CMakeLists.txt LICENSE) # add here all the files you need
add_custom_command(OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/package_files.zip
        COMMAND ${CMAKE_COMMAND} -E tar c ${CMAKE_CURRENT_BINARY_DIR}/package_files.zip --format=zip -- ${FETCH_PACKAGE_FILES}
        WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
        DEPENDS ${FETCH_PACKAGE_FILES})
add_custom_target(create_package_files DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/package_files.zip)
```

This step can be skipped if the repositories are [structured as recommended](ProjectStructure.md) and this repository
is utilized as the central repository. 
In this case, there should be a target called "create_package_files" available. If there are specific files that 
need to be included for compilation, these can be manually set by modifying the "FETCH_PACKAGE_FILES" variable before 
including the "cmakeBase/CMakeLists.txt" file.

## Automation
With the setup complete, CMake will now create an archive in the build directory every time the target is built.
This archive can then be added as an asset in every release. The entire process can be automated when a release 
is created, using GitHub Actions. To do this, simply add a .yml file under the ./github/workflows/ directory 
with the following content:

```yml
name: Release
permissions:
  contents: write

on:
  release:
    types: [published]

jobs:
  release:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3

      - name: Create build environment
        run: cmake -E make_directory build
      - name: Configure
        working-directory: build/
        run: cmake -DGITHUB_ACTION_TRIGGER=ON $GITHUB_WORKSPACE
      - name: Package source code
        working-directory: build/
        run: cmake --build . --target create_package_files

      - name: Add packaged source code to release
        uses: svenstaro/upload-release-action@v2
        with:
          repo_token: ${{ secrets.GITHUB_TOKEN }}
          file: build/package_files.zip
          tag: ${{ github.ref }}
          overwrite: true
```
## Usage
With every new release, an archive will automatically be added, making it available to fetch from other repositories:

```cmake
include(FetchContent)
FetchContent_Declare(
      foo
      URL https://github.com/yourAccount/foo/releases/latest/download/package_files.zip
)
FetchContent_MakeAvailable(foo)
```

The concept behind this was originally proposed by [foonathan](https://github.com/foonathan), for 
more information and details, you can check out his [blog post](https://www.foonathan.net/2022/06/cmake-fetchcontent/).
