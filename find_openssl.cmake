find_path(OPENSSL_LIBRARY_PATH
          NAMES libssl.a
          PATHS
               ${PROJECT_SOURCE_DIR}
               ${CMAKE_DEPENDENT_MODULES_DIR}/lib
               ${CMAKE_DEPENDENT_MODULES_DIR}/lib64
               /usr/local/opt/openssl/lib
               ${LIB_PATH_HINT})

if (NOT OPENSSL_LIBRARY_PATH)
    message(FATAL_ERROR "Can't find Open SSL library")
else ()
    message(STATUS "Open SSL library path: ${OPENSSL_LIBRARY_PATH}/libssl.a")
endif ()
