//
//  SentryCrashMachineContext.c
//
//  Created by Karl Stenerud on 2016-12-02.
//
//  Copyright (c) 2012 Karl Stenerud. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall remain in place
// in this source code.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#include "SentryCrashMachineContext.h"
#include "SentryCrashSystemCapabilities.h"
#include "SentryCrashCPU.h"
#include "SentryCrashStackCursor_MachineContext.h"

//#define SentryCrashLogger_LocalLevel TRACE
#include "SentryCrashLogger.h"

static SentryCrashThread g_reservedThreads[10];
static int g_reservedThreadsMaxIndex = sizeof(g_reservedThreads) / sizeof(g_reservedThreads[0]) - 1;
static int g_reservedThreadsCount = 0;


typedef struct SentryCrashMachineContext
{
    // TODO
} SentryCrashMachineContext;

static inline bool isStackOverflow(const SentryCrashMachineContext* const context)
{
    SentryCrashStackCursor stackCursor;
    sentrycrashsc_initWithMachineContext(&stackCursor, SentryCrashSC_STACK_OVERFLOW_THRESHOLD, context);
    while(stackCursor.advanceCursor(&stackCursor))
    {
    }
    return stackCursor.state.hasGivenUp;
}

int sentrycrashmc_contextSize()
{
    return sizeof(SentryCrashMachineContext);
}

SentryCrashThread sentrycrashmc_getThreadFromContext(const SentryCrashMachineContext* const context)
{
    // TODO
    return 0;
}

bool sentrycrashmc_getContextForThread(SentryCrashThread thread, SentryCrashMachineContext* destinationContext, bool isCrashedContext)
{
    // TODO
    return false;
}

bool sentrycrashmc_getContextForSignal(void* signalUserContext, SentryCrashMachineContext* destinationContext)
{
    // TODO
    return false;
}

void sentrycrashmc_addReservedThread(SentryCrashThread thread)
{
    int nextIndex = g_reservedThreadsCount;
    if(nextIndex > g_reservedThreadsMaxIndex)
    {
        SentryCrashLOG_ERROR("Too many reserved threads (%d). Max is %d", nextIndex, g_reservedThreadsMaxIndex);
        return;
    }
    g_reservedThreads[g_reservedThreadsCount++] = thread;
}

void sentrycrashmc_suspendEnvironment()
{
    // TODO
}

void sentrycrashmc_resumeEnvironment()
{
    // TODO
}

int sentrycrashmc_getThreadCount(const SentryCrashMachineContext* const context)
{
    // TODO
    return 0;
}

SentryCrashThread sentrycrashmc_getThreadAtIndex(const SentryCrashMachineContext* const context, int index)
{
    // TODO
    return 0;

}

int sentrycrashmc_indexOfThread(const SentryCrashMachineContext* const context, SentryCrashThread thread)
{
    // TODO
    return -1;
}

bool sentrycrashmc_isCrashedContext(const SentryCrashMachineContext* const context)
{
    // TODO
    return false;
}

static inline bool isContextForCurrentThread(const SentryCrashMachineContext* const context)
{
    // TODO
    return false;
}

static inline bool isSignalContext(const SentryCrashMachineContext* const context)
{
    // TODO
    return false;
}

bool sentrycrashmc_canHaveCPUState(const SentryCrashMachineContext* const context)
{
    return !isContextForCurrentThread(context) || isSignalContext(context);
}

bool sentrycrashmc_hasValidExceptionRegisters(const SentryCrashMachineContext* const context)
{
    return sentrycrashmc_canHaveCPUState(context) && sentrycrashmc_isCrashedContext(context);
}
