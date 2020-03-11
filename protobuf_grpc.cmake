message(STATUS "Deps prefix: " ${CMAKE_DEPENDENT_MODULES_DIR})

if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/include/google/protobuf/api.proto")
    set(PROTOBUF_INCLUDE_DIR "${CMAKE_DEPENDENT_MODULES_DIR}/include")
else ()
    find_path(PROTOBUF_INCLUDE_DIR google/protobuf/api.proto
              PATH_SUFFIXES include
              PATHS ${PKG_PATH_HINT})
endif ()
set(PROTOBUF_INCLUDE_DIRS ${PROTOBUF_INCLUDE_DIR})
if (NOT PROTOBUF_INCLUDE_DIRS)
    message(FATAL_ERROR "Can't find Protobuf header files")
else ()
    message(STATUS "Protobuf include path: " ${PROTOBUF_INCLUDE_DIRS})
endif ()


if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libprotobuf.so")
    set(PROTOBUF_LIBRARY "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libprotobuf.so")
else ()
    find_library(PROTOBUF_LIBRARY
                 NAMES libprotobuf.so
                 PATHS ${LIB_PATH_HINT})
endif ()
if (NOT PROTOBUF_LIBRARY) # Maybe on Mac?
    if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libprotobuf.dylib")
        set(PROTOBUF_LIBRARY "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libprotobuf.dylib")
    else ()
        find_library(PROTOBUF_LIBRARY
                     NAMES libprotobuf.dylib
                     PATHS ${LIB_PATH_HINT})
    endif()
endif()
if (NOT PROTOBUF_LIBRARY)
    message(FATAL_ERROR "Can't find Protobuf library file")
else ()
    message(STATUS "Protobuf library path: " ${PROTOBUF_LIBRARY})
endif ()


if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/bin/grpc_cpp_plugin")
    set(GRPC_CPP_PLUGIN "${CMAKE_DEPENDENT_MODULES_DIR}/bin")
else ()
    find_path(GRPC_CPP_PLUGIN grpc_cpp_plugin
              PATH_SUFFIXES bin
              PATHS ${PKG_PATH_HINT})
endif ()
if (NOT GRPC_CPP_PLUGIN)
    message(FATAL_ERROR "Can't find grpc_cpp_plugin file")
else ()
    message(STATUS "grpc_cpp_plugin path: " ${GRPC_CPP_PLUGIN}/grpc_cpp_plugin)
endif ()
#find_program(GRPC_CPP_PLUGIN grpc_cpp_plugin) # Get full path to plugin

if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/bin/protoc")
    set(PROTOC_DIR "${CMAKE_DEPENDENT_MODULES_DIR}/bin")
else ()
    find_path(PROTOC_DIR protoc
              PATH_SUFFIXES bin
              PATHS ${PKG_PATH_HINT})
endif ()
if (NOT PROTOC_DIR)
    message(FATAL_ERROR "Can't find protoc executable file")
else ()
    message(STATUS "protoc path: " ${PROTOC_DIR}/protoc)
    set(PROTOBUF_PROTOC_EXECUTABLE ${PROTOC_DIR}/protoc)
endif ()

find_package(Protobuf REQUIRED)


if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libprotobuf.a")
    set(PROTOBUF_STATIC_LIBRARIES "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libprotobuf.a")
else ()
    find_library(PROTOBUF_STATIC_LIBRARIES
                 NAMES libprotobuf.a
                 PATHS ${LIB_PATH_HINT})
endif ()
if (NOT PROTOBUF_STATIC_LIBRARIES)
    message(FATAL_ERROR "Can't find Protobuf static library file")
else ()
    message(STATUS "Protobuf static library path: " ${PROTOBUF_STATIC_LIBRARIES})
endif ()


if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/include/grpc/grpc.h")
    set(GRPC_INCLUDE_DIRS "${CMAKE_DEPENDENT_MODULES_DIR}/include/grpc")
    set(GRPC_INCLUDE_DIR_ROOT "${CMAKE_DEPENDENT_MODULES_DIR}/include")
else ()
    find_path(GRPC_INCLUDE_DIRS grpc.h
              PATH_SUFFIXES include/grpc
              PATHS ${PKG_PATH_HINT})
    find_path(GRPC_INCLUDE_DIR_ROOT grpc++/grpc++.h
              PATH_SUFFIXES include
              PATHS ${PKG_PATH_HINT})
endif ()
if (NOT GRPC_INCLUDE_DIRS)
    message(FATAL_ERROR "Can't find gRPC header files")
else ()
    message(STATUS "gRPC include path: " ${GRPC_INCLUDE_DIRS})
endif ()
if (NOT GRPC_INCLUDE_DIR_ROOT)
    message(FATAL_ERROR "Can't find gRPC header files")
else ()
    message(STATUS "gRPC include path (parent): " ${GRPC_INCLUDE_DIR_ROOT})
endif ()


if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libgrpc.a")
    set(GRPC_LIBRARY "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libgrpc.a")
else ()
    find_library(GRPC_LIBRARY
                 NAMES libgrpc.a
                 PATHS ${LIB_PATH_HINT})
endif()

if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libgrpc++.a")
    set(GRPCPP_LIBRARY "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libgrpc++.a")
else ()
    find_library(GRPCPP_LIBRARY
                 NAMES libgrpc++.a
                 PATHS ${LIB_PATH_HINT})
endif ()

if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libgpr.a")
    set(GPR_LIBRARY "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libgpr.a")
else ()
    find_library(GPR_LIBRARY
                 NAMES libgpr.a
                 PATHS ${LIB_PATH_HINT})
endif ()

if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libcares_static.a")
    set(ARES_LIBRARY "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libcares_static.a")
else ()
    find_library(ARES_LIBRARY
                 NAMES libcares_static.a
                 PATHS ${LIB_PATH_HINT})
endif ()

if (EXISTS "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libaddress_sorting.a")
    set(ADDR_SORTING_LIBRARY "${CMAKE_DEPENDENT_MODULES_DIR}/lib/libaddress_sorting.a")
else ()
    find_library(ADDR_SORTING_LIBRARY
                 NAMES libaddress_sorting.a
                 PATHS ${LIB_PATH_HINT})
endif ()

if (NOT GRPC_LIBRARY)
    message(FATAL_ERROR "Can't find gRPC static library file")
else ()
    message(STATUS "gRPC static library path: " ${GRPC_LIBRARY})
endif ()
if (NOT GRPCPP_LIBRARY)
    message(FATAL_ERROR "Can't find gRPC++ static library file")
else ()
    message(STATUS "gRPC++ static library path: " ${GRPCPP_LIBRARY})
endif ()
if (NOT GPR_LIBRARY)
    message(FATAL_ERROR "Can't find gpr static library file")
else ()
    message(STATUS "gpr static library path: " ${GPR_LIBRARY})
endif ()
if (NOT ADDR_SORTING_LIBRARY)
    message(FATAL_ERROR "Can't find address sorting static library file")
else ()
    message(STATUS "gpr static library path: " ${ADDR_SORTING_LIBRARY})
endif ()
if (NOT ARES_LIBRARY)
    message(FATAL_ERROR "Can't find c-ares static library file")
else ()
    message(STATUS "gpr static library path: " ${ARES_LIBRARY})
endif ()

set(GRPC_LIBRARIES
    ${GRPCPP_LIBRARY}
    ${GRPC_LIBRARY}
    ${GPR_LIBRARY}
    ${ADDR_SORTING_LIBRARY}
    ${ARES_LIBRARY})

function(protobuf_generate_grpc_cpp SRCS HDRS)
  if(NOT ARGN)
    message(SEND_ERROR "Error: protobuf_generate_grpc_cpp() called without any proto files")
    return()
  endif()

  if(PROTOBUF_GENERATE_CPP_APPEND_PATH) # This variable is common for all types of output.
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

  foreach(DIR ${Protobuf_IMPORT_DIRS})
    get_filename_component(ABS_PATH ${DIR} ABSOLUTE)
    list(FIND _protobuf_include_path ${ABS_PATH} _contains_already)
    if(${_contains_already} EQUAL -1)
        list(APPEND _protobuf_include_path -I ${ABS_PATH} )
    endif()
  endforeach()

  set(${SRCS})
  set(${HDRS})
  foreach(FIL ${ARGN})
    get_filename_component(ABS_FIL ${FIL} ABSOLUTE)
    get_filename_component(FIL_WE ${FIL} NAME_WE)

    list(APPEND ${SRCS} "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.cc")
    list(APPEND ${HDRS} "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.h")

    add_custom_command(
      OUTPUT "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.cc"
             "${CMAKE_CURRENT_BINARY_DIR}/${FIL_WE}.grpc.pb.h"
      COMMAND ${PROTOC_DIR}/protoc
      ARGS --grpc_out=${CMAKE_CURRENT_BINARY_DIR}
           --plugin=protoc-gen-grpc=${GRPC_CPP_PLUGIN}/grpc_cpp_plugin
           --proto_path=${PROTOBUF_INCLUDE_DIRS}
           ${_protobuf_include_path} ${ABS_FIL}
      DEPENDS ${ABS_FIL} ${Protobuf_PROTOC_EXECUTABLE}
      COMMENT "Running gRPC C++ protocol buffer compiler on ${FIL}"
      VERBATIM)
  endforeach()

  set_source_files_properties(${${SRCS}} ${${HDRS}} PROPERTIES GENERATED TRUE)
  set(${SRCS} ${${SRCS}} PARENT_SCOPE)
  set(${HDRS} ${${HDRS}} PARENT_SCOPE)
endfunction()
