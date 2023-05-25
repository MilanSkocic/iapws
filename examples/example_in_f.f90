program example_in_f
    use iso_fortran_env
    use iapws_g704
    implicit none
    real(real64) :: T(1), kh(1), kd(1)
    character(len=2) :: gas = "O2"
    integer(int32) :: heavywater = 0
    character(len=iapws_g704_GAS_LENGTH), pointer :: gases(:) => null()

    ! Compute kh and kd in H2O
    T(1) = 25.0d0
    call iapws_g704_kh(T, gas, heavywater, kh)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F10.4)", "Gas=", gas, "T=", T, "C", "kh=", kh
    
    call iapws_g704_kd(T, gas, heavywater, kd)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F15.4)", "Gas=", gas, "T=", T, "C", "kh=", kd

    ! Get and print available gases
    print *, "Gases in H2O"
    heavywater = 0
    gases => null()
    gases => iapws_g704_gases(heavywater)
    print *, gases
    
    print *, "Gases in D2O"
    heavywater = 1
    gases => null()
    gases => iapws_g704_gases(heavywater)
    print *, gases

end program