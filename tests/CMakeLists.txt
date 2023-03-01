# tests

add_executable(test_water test_water.c)
target_include_directories(test_water PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_water PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_water PRIVATE m iapws)