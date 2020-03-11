cmake_minimum_required(VERSION 3.5)

# === Build type (default: RelWithDebInfo, O2) ===========
if (NOT CMAKE_BUILD_TYPE)
    set(DEFAULT_BUILD_TYPE "Debug")
endif ()
message(STATUS "Build type: " ${CMAKE_BUILD_TYPE})

set(CMAKE_DEPENDENT_MODULES_DIR "${PROJECT_SOURCE_DIR}/deps_prefix")

set(LIB_PATH_HINT
    ~/Library/Frameworks
    /Library/Frameworks
    $ENV{HOME}/local/lib64
    $ENV{HOME}/local/lib
    /usr/lib
    /usr/lib/x86_64-linux-gnu
    /usr/lib64
    /usr/local/lib
    /usr/local/lib64
    /opt/local/lib
    /opt/local/lib64
    /opt/csw
    /opt)
set(PKG_PATH_HINT
    ~/Library/Frameworks
    /Library/Frameworks
    /usr
    /usr/local
    /opt/local
    /opt/csw
    /opt)

# === Protobuf ============
include(protobuf_grpc.cmake)
include_directories(${PROTOBUF_INCLUDE_DIR})
include_directories(${GRPC_INCLUDE_DIRS})
include_directories(${GRPC_INCLUDE_DIR_ROOT})
include_directories(${CMAKE_CURRENT_BINARY_DIR})

# === Open SSL ===
include(find_openssl.cmake)

# Includes
include_directories(BEFORE ./)
include_directories(BEFORE ${CMAKE_DEPENDENT_MODULES_DIR}/include)
if (APPLE)
    include_directories(BEFORE /usr/local/opt/openssl/include)
    link_directories(/usr/local/opt/openssl/lib)
endif ()

# Compiler flags
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wno-pessimizing-move")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++14")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -g")
if (NOT APPLE)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
endif ()

# if (JEMALLOC GREATER 0)
    # set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -DUSE_JEMALLOC")
    # message(STATUS "---- USE JEMALLOC ----")
# endif ()

# Protobuf file for KV
set(PROTO_FILES
    test.proto)
protobuf_generate_cpp(PROTO_SRCS PROTO_HDRS ${PROTO_FILES})
protobuf_generate_grpc_cpp(PROTO_GRPC_SRCS PROTO_GRPC_HDRS ${PROTO_FILES})

# Make an internal library to avoid duplicate compiling.
set(MAIN_SRC 
    main.cc
    ${PROTO_HDRS}
    ${PROTO_SRCS}
    ${PROTO_GRPC_HDRS}
    ${PROTO_GRPC_SRCS})
    

add_executable(stream_test ${MAIN_SRC})
target_link_libraries(stream_test
                      ${GLOG_LIBRARY}
                      ${GFLAGS_LIBRARY}
                      ${JEMALLOC_LIBRARY}
                      ${LIBBOOST_THREAD_PATH}
                      ${PROTOBUF_STATIC_LIBRARIES}
                      ${GRPC_LIBRARIES}
                      ${OPENSSL_LIBRARY_PATH}/libssl.a
                      ${OPENSSL_LIBRARY_PATH}/libcrypto.a
                      z
                      dl)
