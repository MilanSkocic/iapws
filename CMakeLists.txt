cmake_minimum_required(VERSION 3.10)

project("pciapws" VERSION "0.1" LANGUAGES "C" DESCRIPTION "Compute the solubility of different gases in water and heavywater. Supported gases in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6. Supported gases in heavywater: He, Ne, Ar, Kr, Xe, D2, CH4")
configure_file("./src/version.h.in" "./src/version.h")

SET(MSYS_ROOT "/c/msys64/" CACHE STRING "Msys root folder.")

message("Build type:" ${CMAKE_BUILD_TYPE})
message("C FLAGS DEBUG:" ${CMAKE_C_FLAGS_DEBUG})
message("C FLAGS RELEASE:" ${CMAKE_C_FLAGS_RELEASE})
message("INSTALL PREFIX:" ${CMAKE_INSTALL_PREFIX})

if (MSYS)
    message("MSYS ROOT: " ${MSYS_ROOT})
endif()

add_subdirectory(./src)

enable_testing()
add_test(NAME solubility COMMAND test_solubility)
add_test(NAME utilities COMMAND test_utilities)

install(TARGETS ${PROJECT_NAME} RUNTIME DESTINATION bin)
install(TARGETS static_iapws DESTINATION include ARCHIVE DESTINATION lib)
install(TARGETS shared_iapws PUBLIC_HEADER DESTINATION include LIBRARY DESTINATION lib)

if(WIN32 OR MSYS)
    install(FILES "${MSYS_ROOT}usr/bin/msys-argp-0.dll" DESTINATION bin)
    install(FILES "${MSYS_ROOT}usr/bin/msys-2.0.dll" DESTINATION bin)
    install(TARGETS static_iapws DESTINATION bin)
    install(TARGETS shared_iapws DESTINATION bin)
endif()
