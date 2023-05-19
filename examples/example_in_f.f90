program example_in_f
    use iso_fortran_env
    use iapws_g704
    implicit none
    real(real64) :: T(1), kh(1), kd(1)
    character(len=5) :: gas = "O2"
    
    T(1) = 25.0d0

    call iapws_g704_kh(T, gas, 0, kh)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F10.4)", "Gas=", gas, "T=", T, "C", "kh=", kh
    
    call iapws_g704_kd(T, gas, 0, kd)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F15.4)", "Gas=", gas, "T=", T, "C", "kh=", kd

end program