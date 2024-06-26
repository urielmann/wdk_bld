#
# @file wdk_bld/CMakeLists.txt
# @brief CMake configuration
#
# @copyright (C) 2024 Uriel Mann (abba.mann@gmail.com)
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sub-license, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:

# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.

# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

cmake_minimum_required(VERSION 3.11)

project(wdk_bld
    VERSION 0.0.1
    DESCRIPTION "Driver build test")

    # Set a default build type for single-configuration
    # CMake generators if no build type is set.
    if(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)
        set(CMAKE_BUILD_TYPE Debug)
    endif(NOT CMAKE_CONFIGURATION_TYPES AND NOT CMAKE_BUILD_TYPE)

    # Global variables
    set(WDK_DIR "C:/Program Files (x86)/Windows Kits/10/bin/$ENV{WDK_VER}")
    set(TRACEWPP "${WDK_DIR}/$ENV{Platform}/tracewpp.exe")
    file(TO_NATIVE_PATH "${CMAKE_SOURCE_DIR}" NT_CMAKE_SOURCE_DIR)

    add_subdirectory(tst)
