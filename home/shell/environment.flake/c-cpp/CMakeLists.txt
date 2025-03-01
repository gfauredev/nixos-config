#*******************************************************************************
# Authors: Guilhem Fauré
#*******************************************************************************

cmake_minimum_required(VERSION 3.10)
project(splashmem VERSION 1.0)

set(CMAKE_C_COMPILER clang)
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall")

set(EXECUTABLE_NAME main)

add_executable(${EXECUTABLE_NAME} main.c)

# target_link_libraries(${EXECUTABLE_NAME} example)

# add_subdirectory(src)
