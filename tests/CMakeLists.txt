link_directories(${CMAKE_BINARY_DIR}/src)

add_executable(test_solubility test_solubility.c)
target_include_directories(test_solubility PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(test_solubility PUBLIC m iapws)

