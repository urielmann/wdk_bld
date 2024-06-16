/*
* @file wdk_bld/tst/drv.cpp
* @brief WDM driver
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

#include "wpp.h"
#include "drv.cpp.tmh"

extern "C"
{

//---------------------------------------------------------------------------
//  Function prototypes
//---------------------------------------------------------------------------
DRIVER_INITIALIZE DriverEntry;
DRIVER_UNLOAD DriverUnload;
NTSTATUS DriverEntry(_In_ PDRIVER_OBJECT DriverObject,
                     _In_ PUNICODE_STRING RegistryPath);

//---------------------------------------------------------------------------
//  Assign text sections for each routine.
//---------------------------------------------------------------------------

#ifdef ALLOC_PRAGMA
#   pragma alloc_text(INIT, DriverEntry)
#   pragma alloc_text(PAGE, DriverUnload)
#endif

void NTAPI DriverUnload(PDRIVER_OBJECT DriverObject)
{
    TraceInformationDrv(L"Filter unloaded\n");

    WPP_CLEANUP(DriverObject);
}

//---------------------------------------------------------------------------
//  Implementation
//---------------------------------------------------------------------------
NTSTATUS NTAPI DriverEntry(_In_ PDRIVER_OBJECT DriverObject,
                           _In_ PUNICODE_STRING RegistryPath)
{
    WPP_INIT_TRACING(DriverObject, RegistryPath);
    DriverObject->DriverUnload = &DriverUnload;
    return STATUS_SUCCESS;
}

} // extern "C"
