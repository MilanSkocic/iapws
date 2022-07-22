
link_directories(${CMAKE_BINARY_DIR}/src)

add_executable(pciapws main.c)
target_include_directories(pciapws PUBLIC ${CMAKE_SOURCE_DIR}/src ${CMAKE_BINARY_DIR}/src)


if(UNIX)
	set(LINKLIBS "ciapws")
endif()
if(MSYS OR APPLE)
	set(LINKLIBS "ciapws" "argp")
endif()

target_link_libraries(pciapws PUBLIC ${LINKLIBS})
