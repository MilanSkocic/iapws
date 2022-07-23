# tests
add_executable(test_utilities test_utilities.c)
target_include_directories(test_utilities PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_utilities PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_utilities PUBLIC m ciapws)

add_executable(test_solubility test_solubility.c)
target_include_directories(test_solubility PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_solubility PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_solubility PUBLIC m ciapws)

