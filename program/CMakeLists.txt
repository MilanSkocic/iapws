
link_directories(${CMAKE_BINARY_DIR}/src)

add_executable(ciapws main.c)
target_include_directories(ciapws PUBLIC ${CMAKE_SOURCE_DIR}/src)

set(LINKLIBS iapws argp)

if(UNIX AND NOT APPLE)
	set(LINKLIBS "iapws")
else()
	set(LINKLIBS "iapws" "argp")
endif()

target_link_libraries(ciapws PUBLIC ${LINKLIBS})
