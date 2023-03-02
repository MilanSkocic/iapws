set(LINKLIBS "iapws")

if((${CMAKE_C_COMPILER_ID} STREQUAL "GNU") OR (${CMAKE_C_COMPILER_ID} STREQUAL "AppleClang") )
    set(LINKLIBS "m" "iapws")
endif()

add_executable(example_in_c example_in_c.c)
target_include_directories(example_in_c PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(example_in_c PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(example_in_c PRIVATE "${LINKLIBS}")

add_executable(example_in_f example_in_f.f90)
target_include_directories(example_in_f PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(example_in_f PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(example_in_f PRIVATE iapws)