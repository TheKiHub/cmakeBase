find_package(Python3 COMPONENTS Interpreter Development REQUIRED)
add_library(python ALIAS Python3::Python)
