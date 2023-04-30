cmake_minimum_required(VERSION 3.10)

project("iapws" VERSION "X.X.X" LANGUAGES "C" "Fortran" DESCRIPTION "IAPWS")
configure_file("./app/config.h.in" "./app/config.h")

if(NOT CMAKE_BUILD_TYPE)
    set(CMAKE_BUILD_TYPE "release")
endif()

# GNU / AppleClang
set(C_FLAGS_DEBUG_GCC "-std=c11 -Wall -Wextra -pedantic")
set(C_FLAGS_RELEASE_GCC "-std=c11 -O2 -w")

set(Fortran_FLAGS_DEBUG_GCC "-std=f2008 -Wall -Wextra -pedantic")
set(Fortran_FLAGS_RELEASE_GCC "-std=f2008 -O2 -w")

# MSVC
set(C_FLAGS_DEBUG_MSVC "/std:c11 /Wall")
set(C_FLAGS_RELEASE_MSVC "/std:c11 /O2 /w")

# Intel C
set(C_FLAGS_DEBUG_Intel_win32 "/Qstd:c11 /Wall")
set(C_FLAGS_RELEASE_Intel_win32 "/Qstd:c11 /O2 /w")
set(C_FLAGS_DEBUG_Intel_unix "-std=c11 -Wall")
set(C_FLAGS_RELEASE_Intel_unix "-std=c11 -O2 -w")

#Intel Fortran
set(Fortran_FLAGS_DEBUG_Intel_win32 "/stand:f08 /warn ")
set(Fortran_FLAGS_RELEASE_Intel_win32 "/stand:f08 /O2 /w")
set(Fortran_FLAGS_DEBUG_Intel_unix "-stand f08 -Wall ")
set(Fortran_FLAGS_RELEASE_Intel_unix "-stand f08 -O2 -w ")

# C flags
if(CMAKE_C_COMPILER_ID STREQUAL "MSVC")
    set(C_FLAGS_DEBUG "${C_FLAGS_DEBUG_MSVC}")
    set(C_FLAGS_RELEASE "${C_FLAGS_RELEASE_MSVC}")
elseif(CMAKE_C_COMPILER_ID STREQUAL "Intel")
    if(WIN32)
        set(C_FLAGS_DEBUG "${C_FLAGS_DEBUG_Intel_win32}")
        set(C_FLAGS_RELEASE "${C_FLAGS_RELEASE_Intel_win32}")
    elseif()
        set(C_FLAGS_DEBUG "${C_FLAGS_DEBUG_Intel_unix}")
        set(C_FLAGS_RELEASE "${C_FLAGS_RELEASE_Intel_unix}")
    endif()
elseif((CMAKE_C_COMPILER_ID STREQUAL "GNU") OR (CMAKE_C_COMPILER_ID STREQUAL "AppleClang") )
    set(C_FLAGS_DEBUG "${C_FLAGS_DEBUG_GCC}")
    set(C_FLAGS_RELEASE "${C_FLAGS_RELEASE_GCC}")
endif()

# Fortran flags
if(CMAKE_Fortran_COMPILER_ID STREQUAL "Intel")
    if(WIN32)
        set(Fortran_FLAGS_DEBUG "${Fortran_FLAGS_DEBUG_Intel_win32}")
        set(Fortran_FLAGS_RELEASE "${Fortran_FLAGS_RELEASE_Intel_win32}")
    elseif()
        set(Fortran_FLAGS_DEBUG "${Fortran_FLAGS_DEBUG_Intel_unix}")
        set(Fortran_FLAGS_RELEASE "${Fortran_FLAGS_RELEASE_Intel_unix}")
    endif()
elseif()
    set(Fortran_FLAGS_DEBUG "${Fortran_FLAGS_DEBUG_GCC}")
    set(Fortran_FLAGS_RELEASE "${Fortran_FLAGS_RELEASE_GCC}")

endif()

set(CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG} ${C_FLAGS_DEBUG}")
set(CMAKE_Fortran_FLAGS_DEBUG "${CMAKE_Fortran_FLAGS_DEBUG} ${Fortran_FLAGS_DEBUG}")
set(CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE} ${C_FLAGS_RELEASE}")
set(CMAKE_Fortran_FLAGS_RELEASE "${CMAKE_Fortran_FLAGS_RELEASE} ${Fortran_FLAGS_RELEASE}")

message("build type = " ${CMAKE_BUILD_TYPE})
message("CFlags release = " ${CMAKE_C_FLAGS_RELEASE})
message("FFlags release = " ${CMAKE_Fortran_FLAGS_RELEASE})
message("FFlags debug = " ${CMAKE_Fortran_FLAGS_DEBUG})
message("CFlags debug = " ${CMAKE_C_FLAGS_DEBUG})
message("prefix = " ${CMAKE_INSTALL_PREFIX})
message("C Compiler = " ${CMAKE_C_COMPILER})
message("C Compiler ID = " ${CMAKE_C_COMPILER_ID})
message("Fortran Compiler = " ${CMAKE_Fortran_COMPILER})
message("Fortran Compiler ID = " ${CMAKE_Fortran_COMPILER_ID})

add_subdirectory(./src)
add_subdirectory(./tests)
add_subdirectory(./examples)
add_subdirectory(./app)

enable_testing()
add_test(NAME test_water COMMAND test_water)
add_test(NAME test_heavywater COMMAND test_heavywater)

install(TARGETS iapws-config RUNTIME DESTINATION bin)
install(TARGETS static_iapws DESTINATION include ARCHIVE DESTINATION lib)
install(TARGETS shared_iapws PUBLIC_HEADER DESTINATION include LIBRARY DESTINATION lib)