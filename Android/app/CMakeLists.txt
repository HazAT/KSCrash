# Sets the minimum version of CMake required to build the native
# library. You should either keep the default value or only pass a
# value of 3.4.0 or lower.

cmake_minimum_required(VERSION 3.4.1)

# Creates and names a library, sets it as either STATIC
# or SHARED, and provides the relative paths to its source code.
# You can define multiple libraries, and CMake builds it for you.
# Gradle automatically packages shared libraries with your APK.

include_directories(${CMAKE_SOURCE_DIR}/../Source)
include_directories(${CMAKE_SOURCE_DIR}/../Source/monitors)
include_directories(${CMAKE_SOURCE_DIR}/../Source/tools)
include_directories(${CMAKE_SOURCE_DIR}/../../Source/SentryCrash)
include_directories(${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording)
include_directories(${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Monitors)
include_directories(${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools)

add_library( # Sets the name of the library.
             sentrycrash-lib

             # Sets the library as a shared library.
             SHARED

             # Provides a relative path to your source file(s).
             # Associated headers in the same location as their source
             # file are automatically included.
             ${CMAKE_SOURCE_DIR}/../Source/sentrycrash-lib.cpp
             ${CMAKE_SOURCE_DIR}/../Source/SentryCrashCachedData.c
             ${CMAKE_SOURCE_DIR}/../Source/SentryCrashJNI.cpp
             ${CMAKE_SOURCE_DIR}/../Source/monitors/SentryCrashMonitor_System.c
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashCPU.c
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashDebug.c
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashDynamicLinker.c
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashID.cpp
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashMachineContext.c
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashMemory.c
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashStackCursor_SelfThread.c
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashSymbolicator.c
             ${CMAKE_SOURCE_DIR}/../Source/tools/SentryCrashThread.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/SentryCrashC.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/SentryCrashReport.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/SentryCrashReportFixer.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/SentryCrashReportStore.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Monitors/SentryCrashMonitor.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Monitors/SentryCrashMonitor_AppState.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Monitors/SentryCrashMonitor_CPPException.cpp
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Monitors/SentryCrashMonitor_Signal.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Monitors/SentryCrashMonitor_User.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Monitors/SentryCrashMonitorType.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashDate.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashDemangle_CPP.cpp
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashFileUtils.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashJSONCodec.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashLogger.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashSignalInfo.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashStackCursor.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashStackCursor_Backtrace.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashStackCursor_MachineContext.c
             ${CMAKE_SOURCE_DIR}/../../Source/SentryCrash/Recording/Tools/SentryCrashString.c
           )

# Searches for a specified prebuilt library and stores the path as a
# variable. Because system libraries are included in the search path by
# default, you only need to specify the name of the public NDK library
# you want to add. CMake verifies that the library exists before
# completing its build.

find_library( # Sets the name of the path variable.
              log-lib

              # Specifies the name of the NDK library that
              # you want CMake to locate.
              log )

# Specifies libraries CMake should link to your target library. You
# can link multiple libraries, such as libraries you define in the
# build script, prebuilt third-party libraries, or system libraries.

target_link_libraries( # Specifies the target library.
                       sentrycrash-lib

                       # Links the target library to the log library
                       # included in the NDK.
                       ${log-lib} )
