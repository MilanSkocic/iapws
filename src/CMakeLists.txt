
# Library
add_library(static_iapws STATIC ciapws.c utilities.c)
set_target_properties(static_iapws PROPERTIES OUTPUT_NAME ciapws)

add_library(shared_iapws SHARED ciapws.c utilities)
set_target_properties(shared_iapws PROPERTIES OUTPUT_NAME ciapws)

target_include_directories(static_iapws PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(static_iapws PUBLIC m)

target_include_directories(shared_iapws PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(shared_iapws PUBLIC m)

set_target_properties(static_iapws PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/ciapws.h)
set_target_properties(shared_iapws PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/ciapws.h)

# Program
add_executable(${PROJECT_NAME} main.c)
target_include_directories(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/src ${CMAKE_BINARY_DIR}/src)
target_link_directories(pciapws PRIVATE ${CMAKE_BINARY_DIR}/src)


if(UNIX)
	set(LINKLIBS "ciapws")
endif()
if(MSYS OR APPLE)
	set(LINKLIBS "ciapws" "argp")
endif()

target_link_libraries(${PROJECT_NAME} PRIVATE ${LINKLIBS})