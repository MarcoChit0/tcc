# Set the minimum required version of cmake for this project
cmake_minimum_required(VERSION 3.18 FATAL_ERROR)

# Set your project name
project(and_star VERSION 1.0)

# Specify the C++ standard
set(CONDA_PREFIX $ENV{CONDA_PREFIX})
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_COMPILER "${CONDA_PREFIX}/bin/x86_64-conda-linux-gnu-c++")
set(CMAKE_C_COMPILER "${CONDA_PREFIX}/bin/x86_64-conda-linux-gnu-gcc")
set(CMAKE_PREFIX_PATH /home/macsilva/libtorch)

# Find external libraries
find_package(Torch REQUIRED)


# Compiler options
add_compile_options(-O3 -Wno-pmf-conversions -DIL_STD -g -pthread ${TORCH_CXX_FLAGS})

# Find source files
file(GLOB_RECURSE SOURCES RELATIVE ${CMAKE_SOURCE_DIR} "src/*.cpp")

# Specify the binary to build
add_executable(${PROJECT_NAME} ${SOURCES})

# Link with external libraries
target_link_libraries(
    ${PROJECT_NAME}
    ${TORCH_LIBRARIES}
    m
    dl
    gmpxx
    gmp
    pthread
)

# Set the CXX flags for PyTorch
set_property(TARGET ${PROJECT_NAME} PROPERTY CXX_STANDARD 23)