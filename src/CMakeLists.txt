set(IAPWS_PUBLIC_HEADERS "${CMAKE_BINARY_DIR}/src/iapws.mod" "${CMAKE_SOURCE_DIR}/src/iapws.h")
set(IAPWS_SOURCES "iapws_constants.f90" "iapws_G7_04.f90" "iapws.f90" "iapws_capi.f90")

add_library(static_iapws STATIC "${IAPWS_SOURCES}")
set_target_properties(static_iapws PROPERTIES OUTPUT_NAME iapws)

add_library(shared_iapws SHARED "${IAPWS_SOURCES}")
set_target_properties(shared_iapws PROPERTIES OUTPUT_NAME iapws)

target_include_directories(static_iapws PRIVATE ${CMAKE_SOURCE_DIR}/src ${CMAKE_BINARY_DIR}/src)
target_include_directories(shared_iapws PRIVATE ${CMAKE_SOURCE_DIR}/src ${CMAKE_BINARY_DIR}/src)

set_target_properties(static_iapws PROPERTIES PUBLIC_HEADER "${IAPWS_PUBLIC_HEADER}")
set_target_properties(shared_iapws PROPERTIES PUBLIC_HEADER "${IAPWS_PUBLIC_HEADER}")


# Program
# add_executable(iapws_run main.c)
# target_include_directories(iapws_run PRIVATE ${CMAKE_SOURCE_DIR}/src ${CMAKE_BINARY_DIR}/src)
# target_link_directories(iapws_run PRIVATE ${CMAKE_BINARY_DIR}/src)