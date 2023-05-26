set(LINKLIBS "iapws")

if((${CMAKE_C_COMPILER_ID} STREQUAL "GNU") OR (${CMAKE_C_COMPILER_ID} STREQUAL "AppleClang") )
    set(LINKLIBS "m" "iapws")
endif()

add_executable(test_iapws_g704_H2O test_iapws_g704_H2O.c)
target_include_directories(test_iapws_g704_H2O PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_iapws_g704_H2O PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_iapws_g704_H2O PRIVATE "${LINKLIBS}")

add_executable(test_iapws_g704_D2O test_iapws_g704_D2O.c)
target_include_directories(test_iapws_g704_D2O PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_iapws_g704_D2O PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_iapws_g704_D2O PRIVATE "${LINKLIBS}")

add_executable(test_iapws_g704_ngases test_iapws_g704_ngases.c)
target_include_directories(test_iapws_g704_ngases PRIVATE ${CMAKE_SOURCE_DIR}/src)
target_link_directories(test_iapws_g704_ngases PRIVATE ${CMAKE_BINARY_DIR}/src)
target_link_libraries(test_iapws_g704_ngases PRIVATE "${LINKLIBS}")