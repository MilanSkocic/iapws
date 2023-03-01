cmake_minimum_required(VERSION 3.10)

project("iapws" VERSION "0.1" LANGUAGES "C" "Fortran" DESCRIPTION "IAPWS")
configure_file("./src/version.h.in" "./src/version.h")

message("Build type:" ${CMAKE_BUILD_TYPE})
message("C FLAGS DEBUG:" ${CMAKE_C_FLAGS_DEBUG})
message("C FLAGS RELEASE:" ${CMAKE_C_FLAGS_RELEASE})
message("Fortran FLAGS DEBUG:" ${CMAKE_C_FLAGS_DEBUG})
message("Fortran FLAGS RELEASE:" ${CMAKE_C_FLAGS_RELEASE})
message("INSTALL PREFIX:" ${CMAKE_INSTALL_PREFIX})

add_subdirectory(./src)
add_subdirectory(./tests)

enable_testing()
add_test(NAME test_water COMMAND test_water)
# add_test(NAME utilities COMMAND test_utilities)

# install(TARGETS iapws_run RUNTIME DESTINATION bin)
# install(TARGETS static_iapws DESTINATION include ARCHIVE DESTINATION lib)
# install(TARGETS shared_iapws PUBLIC_HEADER DESTINATION include LIBRARY DESTINATION lib)