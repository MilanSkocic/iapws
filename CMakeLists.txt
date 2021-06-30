cmake_minimum_required(VERSION 3.10)

project(iapws VERSION 1.1 LANGUAGES C)

set(CMAKE_INSTALL_PREFIX C:/Users/mskocic/LocalApps/)

set(NAME ${PROJECT_NAME})
add_executable(${PROJECT_NAME} src/main.c src/iapws.c src/utilities.c)

target_link_libraries(${PROJECT_NAME} PRIVATE m argp)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
