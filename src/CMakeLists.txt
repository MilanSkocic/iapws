
# Library
add_library(static_iapws STATIC iapws.c utilities.c iapws_constants.f90 iapws_G7_04.f90)
set_target_properties(static_iapws PROPERTIES OUTPUT_NAME iapws)

add_library(shared_iapws SHARED iapws.c utilities)
set_target_properties(shared_iapws PROPERTIES OUTPUT_NAME iapws)

target_include_directories(static_iapws PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(static_iapws PRIVATE m)

target_include_directories(shared_iapws PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_libraries(shared_iapws PRIVATE m)

set_target_properties(static_iapws PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/iapws.h)
set_target_properties(shared_iapws PROPERTIES PUBLIC_HEADER ${CMAKE_SOURCE_DIR}/src/iapws.h)

# tests
add_executable(test_utilities test_utilities.c)
target_include_directories(test_utilities PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_utilities PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_utilities PRIVATE m iapws)

add_executable(test_solubility test_solubility.c)
target_include_directories(test_solubility PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_solubility PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_solubility PRIVATE m iapws)

# Program
add_executable(iapws_run main.c)
target_include_directories(iapws_run PRIVATE ${CMAKE_SOURCE_DIR}/src ${CMAKE_BINARY_DIR}/src)
target_link_directories(iapws_run PRIVATE ${CMAKE_BINARY_DIR}/src)


if(UNIX)
	set(LINKLIBS "iapws")
endif()
if(MSYS OR APPLE)
	set(LINKLIBS "iapws" "argp")
endif()

target_link_libraries(iapws_run PRIVATE ${LINKLIBS})