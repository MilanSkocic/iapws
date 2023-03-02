set(LINKLIBS "iapws")

if((${CMAKE_C_COMPILER_ID} STREQUAL "GNU") OR (${CMAKE_C_COMPILER_ID} STREQUAL "AppleClang") )
    set(LINKLIBS "m" "iapws")
endif()

add_executable(test_water test_water.c)
target_include_directories(test_water PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_water PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_water PRIVATE "${LINKLIBS}")

add_executable(test_heavywater test_heavywater.c)
target_include_directories(test_heavywater PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_heavywater PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_heavywater PRIVATE "${LINKLIBS}")