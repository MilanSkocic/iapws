cmake_minimum_required(VERSION 3.10)

project(iapws VERSION 1.1 LANGUAGES C)

set(CMAKE_INSTALL_PREFIX C:/Users/mskocic/LocalApps/)


# Conditions for platforms
if(WIN32)
    MESSAGE(STATUS "WIN32")
    set(OUTPUT_DIR windows)
    set(INC_DIR C:/msys64/usr/include C:/msys64/mingw64/include)
    set(LIB_DIR C:/msys64/usr/lib C:/msys64/mignw64/lib)
    set(LIBS m argp)
elseif(UNIX)
    MESSAGE(STATUS "UNIX")
    set(OUTPUT_DIR unix)
    set(INC_DIR /usr/include /usr/local/include)
    set(LIB_DIR /usr/lib /usr/local/lib)
    set(LIBS m argp)
endif()

set(NAME ${PROJECT_NAME})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${OUTPUT_DIR})
add_executable(${PROJECT_NAME} src/main.c src/iapws.c src/utilities.c)

target_link_libraries(${PROJECT_NAME} PRIVATE ${LIBS})
target_include_directories(${PROJECT_NAME} PRIVATE ${INC_DIR})
target_link_directories(${PROJECT_NAME} PRIVATE ${LIB_DIR})

set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${NAME})


install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
