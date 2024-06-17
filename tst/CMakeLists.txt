#
# @file wdk_bld/tst/CMakeLists.txt
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

# All source files
set(CPP_SOURCES drv.cpp)
set(RES_SOURCES drv.rc)

set(SOURCES ${CPP_SOURCES} ${RES_SOURCES})
set(WPP_SOURCES ${CPP_SOURCES})
list(TRANSFORM WPP_SOURCES APPEND .tmh)

#
# Build WPP headers
#
project(drv_wpp)
    add_custom_target(${PROJECT_NAME} ${TRACEWPP} -v1 -km -TimeChk -UnicodeIgnore
                                                -gen:{km-default.tpl}*.tmh
                                                -DefWpp:${WDK_DIR}/WppConfig/Rev1/defaultwpp.ini
                                                -CfgDir:${WDK_DIR}/WppConfig/Rev1
                                                -oDir:${PROJECT_BINARY_DIR}
                                                -ext:.h.cpp -PreserveExt:.h.cpp
                                                -Scan:${PROJECT_SOURCE_DIR}/wpp.h
                                                ${CPP_SOURCES}
        COMMAND cd ${PROJECT_SOURCE_DIR}
        VERBATIM
        BYPRODUCTS ${WPP_SOURCES}
        SOURCES ${CPP_SOURCES}
        WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
        )

#
# Build driver
#
project(drv CXX)
    list(TRANSFORM SOURCES PREPEND ${PROJECT_SOURCE_DIR}/)
    #message(STATUS "After SOURCES: ${SOURCES}")

    add_executable(${PROJECT_NAME} )
    source_group("Header Files" FILES ${HPP_SOURCES})
    source_group("Resource Files" FILES ${RES_SOURCES})
    source_group("Source Files" FILES ${CPP_SOURCES})

    # Remove all defaults
    set(CMAKE_CXX_FLAGS "")
    set(CMAKE_CXX_FLAGS_RELWITHDEBINFO  "")
    set(CMAKE_CXX_FLAGS_MINSIZEREL  "")
    set(CMAKE_CXX_FLAGS_RELEASE "")
    set(CMAKE_CXX_FLAGS_DEBUG /D_DEBUG /DDBG=1)
    set(CMAKE_EXE_LINKER_FLAGS /NODEFAULTLIB)
    set(CMAKE_EXE_LINKER_FLAGS_RELWITHDEBINFO /RELEASE)
    set(CMAKE_EXE_LINKER_FLAGS_MINSIZEREL /RELEASE)
    set(CMAKE_EXE_LINKER_FLAGS_RELEASE /RELEASE)
    set(CMAKE_EXE_LINKER_FLAGS_DEBUG /DEBUG)

    # Driver defintions
    target_compile_definitions(${PROJECT_NAME} PRIVATE
            _WIN64
            _AMD64_
            AMD64
            DEPRECATE_DDK_FUNCTIONS=1
            MSC_NOOPT
            _WIN32_WINNT=0x0A00
            WINVER=0x0A00
            WINNT=1
            NTDDI_VERSION=0x0A000008
        )
    target_compile_options(${PROJECT_NAME} PRIVATE
            /kernel
            /Zi
            /W4
            /WX
            /Od
            /GF
            /Gm-
            /Zp8
            /GS
            /Gy
            /GR-
            /FC
            /fp:precise
            /Qspectre
            /Zc:wchar_t
            /Zc:forScope
            /guard:cf
            /Zc:inline
            /std:c++20
            /external:W4
            /wd4748
            /wd4603
            /wd4627
            /wd4986
            /wd4987
            /Zc:strictStrings-
            /cbstring
            /d2epilogunwind
            /d1import_no_registry
            /d2AllowCompatibleILVersions
            /d2Zi+
            "/FIC:/Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/Shared/warning.h"
        )
    target_include_directories(${PROJECT_NAME} PRIVATE
            "C:/Program Files (x86)/Windows Kits/10/Include/10.0.19041.0/km"
            ${PROJECT_BINARY_DIR}
        )
    target_link_options(${PROJECT_NAME} PRIVATE
            /OUT:${PROJECT_BINARY_DIR}/drv.sys
            /PDB:${PROJECT_BINARY_DIR}/drv.pdb
            /MAP:${PROJECT_BINARY_DIR}/drv.map
            /IMPLIB:${PROJECT_BINARY_DIR}/drv.lib
            "/LIBPATH:C:/Program Files (x86)/Windows Kits/10/Lib/10.0.19041.0/km/$ENV{Platform}"
            /kernel
            /Driver
            /VERSION:10.0
            /INCREMENTAL:NO
            /SECTION:INIT,d
            /NODEFAULTLIB
            /MANIFEST:NO
            /DEBUG:FULL
            /SUBSYSTEM:NATIVE,10.00
            /OPT:REF
            /OPT:ICF
            /ENTRY:GsDriverEntry
            /MERGE:_TEXT=.text
            /MERGE:_PAGE=PAGE
            /MACHINE:X64
            /PROFILE
            /guard:cf
            /WX
            /IGNORE:4198,4010,4037,4039,4065,4070,4078,4087,4089,4221,4108,4088,4218,4218,4235
            /osversion:10.0
            /pdbcompress
            /debugtype:pdata
            /NODEFAULTLIB
        )

    # Remove default libraries
    target_link_libraries(${PROJECT_NAME} PRIVATE
            bufferoverflowfastfailk.lib
            ntoskrnl.lib
            hal.lib
            wmilib.lib
        )
    target_sources(${PROJECT_NAME} PRIVATE ${SOURCES})

    add_dependencies(${PROJECT_NAME} ${PROJECT_NAME}_wpp)
