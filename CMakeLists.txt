cmake_minimum_required(VERSION 3.10)

project("ciapws" VERSION "0.1" LANGUAGES "C" DESCRIPTION "Compute the solubility of different gases in water and heavywater. Supported gases in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6. Supported gases in heavywater: He, Ne, Ar, Kr, Xe, D2, CH4")
configure_file("./src/version.h.in" "./src/version.h")


message("Build type:" ${CMAKE_BUILD_TYPE})
message("C FLAGS DEBUG:" ${CMAKE_C_FLAGS_DEBUG})
message("C FLAGS RELEASE:" ${CMAKE_C_FLAGS_RELEASE})
message("INSTALL PREFIX:" ${CMAKE_INSTALL_PREFIX})



add_subdirectory(./src)
add_subdirectory(./tests)
add_subdirectory(./program)


enable_testing()
add_test(NAME solubility COMMAND test_solubility)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
install(TARGETS static_iapws DESTINATION include ARCHIVE DESTINATION lib)
install(TARGETS shared_iapws PUBLIC_HEADER DESTINATION include LIBRARY DESTINATION lib)

if(WIN32)
    install(FILES "C:/msys64/usr/bin/msys-argp-0.dll" DESTINATION bin)
    install(FILES "C:/msys64/usr/bin/msys-2.0.dll" DESTINATION bin)
    install(TARGETS static_iapws DESTINATION bin)
    install(TARGETS shared_iapws DESTINATION bin)
endif()
