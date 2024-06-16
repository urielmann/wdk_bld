/*
* @file wdk_bld/tst/wpp.h
* @brief WPP utilities
* @author Uriel Mann
*
* Copyright (C) 2024 Uriel Mann (abba.mann@gmail.com)
*
* Permission is hereby granted, free of charge, to any person obtaining a copy
* of this software and associated documentation files (the "Software"), to deal
* in the Software without restriction, including without limitation the rights
* to use, copy, modify, merge, publish, distribute, sub-license, and/or sell
* copies of the Software, and to permit persons to whom the Software is
* furnished to do so, subject to the following conditions:

* The above copyright notice and this permission notice shall be included in all
* copies or substantial portions of the Software.

* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
* IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
* AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
* LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
* OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
* SOFTWARE.
*/

#pragma once

#if defined(_KERNEL_MODE)
#include <fltKernel.h>
#endif
#include <sal.h>

#if !defined(WPP_LEVEL_FLAGS_ENABLED)
#   define WPP_LEVEL_FLAGS_ENABLED(lvl,flags) (WPP_FLAG_ENABLED(flags) && (WPP_CONTROL(WPP_BIT_ ## flags).Level >= lvl))
#endif

#if !defined(WPP_LEVEL_FLAGS_LOGGER)
#   define WPP_LEVEL_FLAGS_LOGGER(lvl,flags) WPP_FLAG_LOGGER(flags)
#endif

#if !defined(WPP_GLOBALLOGGER)
#   define WPP_GLOBALLOGGER 
#endif

// Kernel WPP CONTROL GUID
#   ifndef WPP_CONTROL_GUIDS
#   define WPP_CONTROL_GUIDS \
        WPP_DEFINE_CONTROL_GUID(DRVWPPGUID,(41791FF4,67B9,43F0,8333,0C53B0746617), \
        WPP_DEFINE_BIT(TRACE_DRIVER))
#   endif // WPP_CONTROL_GUIDS

//
// This comment block is scanned by the trace preprocessor to define the 
// TraceEvents function.
//
// begin_wpp config
//
// FUNC TraceEvents(LEVEL, FLAGS, MSG, ...);
// FUNC TraceVerboseDrv{LEVEL=TRACE_LEVEL_VERBOSE, FLAGS=TRACE_DRIVER}(MSG, ...);
// FUNC TraceInformationDrv{LEVEL=TRACE_LEVEL_INFORMATION, FLAGS=TRACE_DRIVER}(MSG, ...);
// FUNC TraceWarningDrv{LEVEL=TRACE_LEVEL_WARNING, FLAGS=TRACE_DRIVER}(MSG, ...);
// FUNC TraceErrorDrv{LEVEL=TRACE_LEVEL_ERROR, FLAGS=TRACE_DRIVER}(MSG, ...);
//
// end_wpp
//
