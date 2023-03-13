add_executable(iapws-config config.c)
target_include_directories(iapws-config PRIVATE ${CMAKE_BINARY_DIR}/app)