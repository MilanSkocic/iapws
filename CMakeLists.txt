cmake_minimum_required(VERSION 3.10)

project(iapws VERSION 1.1 LANGUAGES C)

set(CMAKE_INSTALL_PREFIX C:/Users/mskocic/LocalApps/)

set(LINK_LIBS_WIN32 )
set(LINK_LIBS_WIN32_MSYS m argp)
set(INCLUDE_DIRS_WIN32_MSYS C:/msys64/mingw64/include C:/msys64/usr/include)
set(LINK_LIBS_UNIX m argp)
set(LINK_LIBS_UNIX_MSYS m argp)
set(INCLUDE_DIRS_UNIX )


# Conditions for platforms
if(WIN32)
    MESSAGE(STATUS "WIN32")
    set(OUTPUT_DIR windows)
    set(INCLUDE_DIRECTORIES ${INCLUDE_DIRS_WIN32_MSYS})
    if(MSYS)
        MESSAGE(STATUS "WIN32 and MSYS")
        set(LINK_LIBS ${LINK_LIBS_WIN32_MSYS})
    elseif(MINGW)
        MESSAGE(STATUS "WIN32 and MinGW")
        set(LINK_LIBS ${LINK_LIBS_WIN32_MSYS})
    endif()
elseif(UNIX)
    MESSAGE(STATUS "UNIX")
    set(OUTPUT_DIR unix)
    set(LINK_LIBS ${LINK_LIBS_UNIX})
    set(INCLUDE_DIRECTORIES ${INCLUDE_DIRS_UNIX})
endif()

set(NAME ${PROJECT_NAME})
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY ${CMAKE_BINARY_DIR}/${OUTPUT_DIR})
        

add_executable(${PROJECT_NAME} src/main.c src/iapws.c src/utilities.c)
target_link_libraries(${PROJECT_NAME} ${LINK_LIBS})
set_target_properties(${PROJECT_NAME} PROPERTIES OUTPUT_NAME ${NAME})


install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
