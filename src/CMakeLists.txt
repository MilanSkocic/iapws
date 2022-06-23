
add_library(static_iapws STATIC iapws.c utilities.c)
set_target_properties(static_iapws PROPERTIES OUTPUT_NAME iapws)

add_library(shared_iapws SHARED iapws.c utilities)
set_target_properties(shared_iapws PROPERTIES OUTPUT_NAME iapws)

target_include_directories(static_iapws PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(static_iapws PUBLIC m)

target_include_directories(shared_iapws PUBLIC ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(shared_iapws PUBLIC m)

set_target_properties(static_iapws PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/iapws.h)
set_target_properties(shared_iapws PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/iapws.h)