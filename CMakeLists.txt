cmake_minimum_required(VERSION 3.0)
project(sylar)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED True)
set(CMAKE_CXX_EXTENSIONS False)
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED True)
set(CMAKE_C_EXTENSIONS False)

set(CMAKE_VERBOSE_MAKEFILE ON)

add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/thirdpart/yaml-cpp-0.6.3)
add_subdirectory(${CMAKE_CURRENT_SOURCE_DIR}/thirdpart/jsoncpp-1.8.4)

set(CMAKE_CXX_FLAGS "$ENV{CXXFLAGS} -rdynamic -O3 -fPIC -ggdb -std=c++11 -Wall -Wno-deprecated -Wno-unused-function -Wno-builtin-macro-redefined -Wno-deprecated-declarations")
set(CMAKE_C_FLAGS "$ENV{CXXFLAGS} -rdynamic -O3 -fPIC -ggdb -std=c11 -Wall -Wno-deprecated -Wno-unused-function -Wno-builtin-macro-redefined -Wno-deprecated-declarations")

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_CURRENT_SOURCE_DIR}/cmake)

include (cmake/utils.cmake)
include_directories("/usr/lcoal/include")
include_directories(".")
include_directories("thirdpart/mysql-connector-c-6.1.11/include")

find_package(Protobuf)
if(Protobuf_FOUND)
    include_directories(${Protobuf_INCLUDE_DIRS})
endif()
# /usr/share/cmake-3.22/Modules/FindBoost.cmake
find_package(Boost REQUIRED)
if(Boost_FOUND)
    include_directories(${Boost_INCLUDE_DIRS})
endif()

#/usr/share/cmake-3.22/Modules/FindOpenSSL.cmake
find_package(OpenSSL REQUIRED)  
if(OPENSSL_FOUND)
    include_directories(${OPENSSL_INCLUDE_DIR})
endif()

#/usr/share/cmake-3.22/Modules/FindZLIB.cmake
find_package(ZLIB REQUIRED)
if(ZLIB_FOUND)
    include_directories(${ZLIB_INCLUDE_DIR})
endif()


set(LIB_SRC
    sylar/address.cc
    sylar/bytearray.cc
    sylar/config.cc
    sylar/db/fox_thread.cc
    sylar/db/mysql.cc
    sylar/db/redis.cc
    sylar/env.cc
    sylar/daemon.cc
    sylar/fd_manager.cc
    sylar/fiber.cc
    sylar/http/http.cc
    sylar/http/http_connection.cc
    sylar/http/http_parser.cc
    sylar/http/http_session.cc
    sylar/http/http_server.cc
    sylar/http/servlet.cc
    sylar/http/servlets/config_servlet.cc
    sylar/http/servlets/status_servlet.cc
    sylar/http/session_data.cc
    sylar/http/ws_connection.cc
    sylar/http/ws_session.cc
    sylar/http/ws_server.cc
    sylar/http/ws_servlet.cc
    sylar/hook.cc
    sylar/iomanager.cc
    sylar/library.cc
    sylar/log.cc
    sylar/module.cc
    sylar/mutex.cc
    sylar/ns/name_server_module.cc
    sylar/ns/ns_client.cc
    sylar/ns/ns_protocol.cc
    sylar/protocol.cc
    sylar/rock/rock_protocol.cc
    sylar/rock/rock_server.cc
    sylar/rock/rock_stream.cc
    sylar/scheduler.cc
    sylar/socket.cc
    sylar/stream.cc
    sylar/streams/async_socket_stream.cc
    sylar/streams/socket_stream.cc
    sylar/streams/load_balance.cc
    sylar/streams/service_discovery.cc
    sylar/streams/zlib_stream.cc
    sylar/tcp_server.cc
    sylar/timer.cc
    sylar/thread.cc
    sylar/util.cc
    # sylar/util/crypto_util.cc
    sylar/util/json_util.cc
    sylar/util/hash_util.cc
    sylar/worker.cc
    sylar/application.cc
    sylar/zk_client.cc
    )

ragelmaker(sylar/http/http11_parser.rl LIB_SRC ${CMAKE_CURRENT_SOURCE_DIR}/sylar/http)
ragelmaker(sylar/http/httpclient_parser.rl LIB_SRC ${CMAKE_CURRENT_SOURCE_DIR}/sylar/http)
ragelmaker(sylar/uri.rl LIB_SRC ${CMAKE_CURRENT_SOURCE_DIR}/sylar)
protobufmaker(sylar/ns/ns_protobuf.proto LIB_SRC ${CMAKE_CURRENT_SOURCE_DIR})

message(STATUS ${LIB_SRC})

add_library(sylar SHARED ${LIB_SRC})
find_library(MYSQL mysqlclient "thirdpart/mysql-connector-c-6.1.11/lib")
find_library(REDIS hiredis_vip)

force_redefine_file_macro_for_sources(sylar)

set(LIBS
        sylar
        pthread
        jsoncpp
        yaml-cpp
        event
        zookeeper_mt
        ${REDIS}
        ${MYSQL}
        ${ZLIB_LIBRARIES}
        ${OPENSSL_LIBRARIES}
        ${Boost_LIBRARIES}
        ${Protobuf_LIBRARIES}
        )

sylar_add_executable(bin_sylar "sylar/main.cc" sylar "${LIBS}")
set_target_properties(bin_sylar PROPERTIES OUTPUT_NAME "sylar")


SET(EXECUTABLE_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/bin)
SET(LIBRARY_OUTPUT_PATH ${PROJECT_SOURCE_DIR}/lib)
