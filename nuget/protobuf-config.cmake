# - Nuget specific protobuf-config cmake file
#
# Copyright 2009 Kitware, Inc.
# Copyright 2009-2011 Philip Lowman <philip@yhbt.com>
# Copyright 2008 Esben Mose Hansen, Ange Optimization ApS
# Copyright Guillaume Dumont, 2014 [https://github.com/willyd]
# Copyright Bonsai AI, 2015 [http://bonsai.ai]
#
# Distributed under the OSI-approved BSD License (the "License");
# see accompanying file Copyright.txt for details.
#
# This software is distributed WITHOUT ANY WARRANTY; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the License for more information.
#=============================================================================
# (To distribute this file outside of CMake, substitute the full
#  License text for the above reference.)
#
# ``PROTOBUF_IMPORT_DIRS``
#   List of additional directories to be searched for
#   imported .proto files.
#
# Defines the following variables:
#
# ``PROTOBUF_INCLUDE_DIRS``
#   Include directories for Google Protocol Buffers
# ``PROTOBUF_LIBRARIES``
#   The protobuf libraries
# ``PROTOBUF_PROTOC_LIBRARIES``
#   The protoc libraries
# ``PROTOBUF_LITE_LIBRARIES``
#   The protobuf-lite libraries
#
# The following cache variables are also available to set or use:
#
# ``PROTOBUF_INCLUDE_DIR``
#   The include directory for protocol buffers
# ``PROTOBUF_PROTOC_EXECUTABLE``
#   The protoc compiler

if(NOT DEFINED protobuf_STATIC)
  # look for global setting
  if(NOT DEFINED BUILD_SHARED_LIBS OR BUILD_SHARED_LIBS)
    option (protobuf_STATIC "Link to static protobuf name" OFF)
  else()
    option (protobuf_STATIC "Link to static protobuf name" ON)
  endif()
endif()

# Determine architecture
if (CMAKE_CL_64)
  set (MSVC_ARCH x64)
else ()
  set (MSVC_ARCH Win32)
endif ()

# Determine VS version
# This build of Protobuf only works with MSVC 12.0 (Visual Studio 2013)
set (MSVC_VERSIONS 1800)
set (MSVC_TOOLSETS v140)

list (LENGTH MSVC_VERSIONS N_VERSIONS)
math (EXPR N_LOOP "${N_VERSIONS} - 1")

foreach (i RANGE ${N_LOOP})        
  list (GET MSVC_VERSIONS ${i} _msvc_version)
  if (_msvc_version EQUAL MSVC_VERSION)
    list (GET MSVC_TOOLSETS ${i} MSVC_TOOLSET)
  endif ()    
endforeach () 
if (NOT MSVC_TOOLSET)
  message( WARNING "Could not find binaries matching your compiler version. Defaulting to v140." )
  set( MSVC_TOOLSET v140 )
endif ()

get_filename_component (CMAKE_CURRENT_LIST_DIR "${CMAKE_CURRENT_LIST_FILE}" PATH)

add_library(protobuf_static_lib STATIC IMPORTED)
set_target_properties(protobuf_static_lib PROPERTIES
  IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Debug/libprotobuf.lib
  IMPORTED_LOCATION_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Release/libprotobuf.lib
  IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
  )

add_library(protobuf_lite_static_lib STATIC IMPORTED)
set_target_properties(protobuf_lite_static_lib PROPERTIES 
  IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Debug/libprotobuf-lite.lib
  IMPORTED_LOCATION_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Release/libprotobuf-lite.lib
  IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
  )

add_library(protoc_static_lib STATIC IMPORTED)
set_target_properties(protoc_static_lib PROPERTIES 
  IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Debug/libprotoc.lib
  IMPORTED_LOCATION_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Release/libprotoc.lib
  IMPORTED_LINK_INTERFACE_LANGUAGES "CXX"
  )

add_library(protobuf_shared_lib SHARED IMPORTED)
set_target_properties(protobuf_shared_lib PROPERTIES 
  IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Debug/libprotobuf.dll
  IMPORTED_IMPLIB_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Debug/libprotobuf.lib
  IMPORTED_LOCATION_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Release/libprotobuf.dll
  IMPORTED_IMPLIB_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Release/libprotobuf.lib
  )

add_library(protobuf_lite_shared_lib SHARED IMPORTED)
set_target_properties(protobuf_lite_shared_lib PROPERTIES
  IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Debug/libprotobuf-lite.dll
  IMPORTED_IMPLIB_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Debug/libprotobuf-lite.lib
  IMPORTED_LOCATION_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Release/libprotobuf-lite.dll
  IMPORTED_IMPLIB_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Release/libprotobuf-lite.lib
  )

add_library(protoc_shared_lib SHARED IMPORTED)
set_target_properties(protoc_shared_lib PROPERTIES
  IMPORTED_LOCATION_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Debug/libprotoc.dll
  IMPORTED_IMPLIB_DEBUG ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Debug/libprotoc.lib
  IMPORTED_LOCATION_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Release/libprotoc.dll
  IMPORTED_IMPLIB_RELEASE ${CMAKE_CURRENT_LIST_DIR}/build/native/lib/${MSVC_ARCH}/${MSVC_TOOLSET}/dynamic/Release/libprotoc.lib
  )

set(PROTOBUF_PROTOC_EXECUTABLE "${CMAKE_CURRENT_LIST_DIR}/build/native/bin/${MSVC_ARCH}/${MSVC_TOOLSET}/static/Release/protoc.exe")
set(PROTOBUF_INCLUDE_DIR "${CMAKE_CURRENT_LIST_DIR}/build/native/include")
set(PROTOBUF_INCLUDE_DIRS "${CMAKE_CURRENT_LIST_DIR}/build/native/include")

if (protobuf_STATIC)
    set (PROTOBUF_LIBRARIES protobuf_static_lib)
    set (PROTOBUF_LITE_LIBRARIES protobuf_lite_static_lib)
    set (PROTOC_LIBRARIES protoc_static_lib)
else ()
    set (PROTOBUF_LIBRARIES protobuf_shared_lib)  
    set (PROTOBUF_LITE_LIBRARIES protobuf_lite_shared_lib)  
    set (PROTOC_LIBRARIES protoc_shared_lib)  
endif()

# The following macro copies DLLs to output.
macro(protobuf_copy_shared_libs target )      
    foreach (_shared_lib ${ARGN})
        add_custom_command( TARGET ${target} POST_BUILD
            COMMAND ${CMAKE_COMMAND} -E copy_if_different 
            $<$<CONFIG:Debug>:$<TARGET_PROPERTY:${_shared_lib},IMPORTED_LOCATION_DEBUG>>
            $<$<NOT:$<CONFIG:Debug>>:$<TARGET_PROPERTY:${_shared_lib},IMPORTED_LOCATION_RELEASE>> 
            $<TARGET_FILE_DIR:${target}>
        )  
    endforeach ()
endmacro()

# This function calls the protoc compiler on proto files
function(PROTOBUF_GENERATE_CPP SRCS HDRS)
  if(NOT ARGN)
    message(SEND_ERROR "Error: PROTOBUF_GENERATE_CPP() called without any proto files")
    return()
  endif()

  if(PROTOBUF_GENERATE_CPP_APPEND_PATH)
    # Create an include path for each file specified
    foreach(FIL ${ARGN})
      get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
      get_filename_component(ABS_PATH ${ABS_FIL} PATH)
      list(FIND _protobuf_include_path ${ABS_PATH} _contains_already)
      if(${_contains_already} EQUAL -1)
          list(APPEND _protobuf_include_path -I ${ABS_PATH})
      endif()
    endforeach()
  else()
    set(_protobuf_include_path -I ${CMAKE_CURRENT_SOURCE_DIR})
  endif()

  if(DEFINED PROTOBUF_IMPORT_DIRS)
    foreach(DIR ${PROTOBUF_IMPORT_DIRS})
      get_filename_component(ABS_PATH ${DIR} ABSOLUTE)
      list(FIND _protobuf_include_path ${ABS_PATH} _contains_already)
      if(${_contains_already} EQUAL -1)
          list(APPEND _protobuf_include_path -I ${ABS_PATH})
      endif()
    endforeach()
  endif()

  set(${SRCS})
  set(${HDRS})
  foreach(FIL ${ARGN})
    get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
    get_filename_component(FIL_WE ${FIL} NAME_WE)

    list(APPEND ${SRCS} "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.pb.cc")
    list(APPEND ${HDRS} "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.pb.h")

    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.pb.cc"
             "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.pb.h"
      COMMAND  ${PROTOBUF_PROTOC_EXECUTABLE}
      ARGS --cpp_out  ${CMAKE_CURRENT_BINARY_DIR} ${_protobuf_include_path} ${ABS_FIL}
      DEPENDS ${ABS_FIL} ${PROTOBUF_PROTOC_EXECUTABLE}
      COMMENT "Running C++ protocol buffer compiler on ${FIL}"
      VERBATIM )
  endforeach()

  set_source_files_properties(${${SRCS}} ${${HDRS}} PROPERTIES GENERATED TRUE)
  set(${SRCS} ${${SRCS}} PARENT_SCOPE)
  set(${HDRS} ${${HDRS}} PARENT_SCOPE)
endfunction()

# By default have PROTOBUF_GENERATE_CPP macro pass -I to protoc
# for each directory where a proto file is referenced.
if(NOT DEFINED PROTOBUF_GENERATE_CPP_APPEND_PATH)
  set(PROTOBUF_GENERATE_CPP_APPEND_PATH TRUE)
endif()

mark_as_advanced(PROTOBUF_INCLUDE_DIR)
mark_as_advanced(PROTOBUF_PROTOC_EXECUTABLE)

