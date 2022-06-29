
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