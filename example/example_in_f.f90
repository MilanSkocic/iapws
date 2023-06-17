program example_in_f
    use iso_fortran_env
    use iapws_g704
    implicit none
    integer(int32) :: i, ngas
    real(real64) :: T(1), kh(1), kd(1)
    character(len=2) :: gas = "O2"
    integer(int32) :: heavywater = 0
    type(iapws_g704_gas_t), pointer :: gases_list(:)
    character(len=:), pointer :: gases_str

    ! Compute kh and kd in H2O
    T(1) = 25.0d0
    call iapws_g704_kh(T, gas, heavywater, kh)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F10.4)", "Gas=", gas, "T=", T, "C", "kh=", kh
    
    call iapws_g704_kd(T, gas, heavywater, kd)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F15.4)", "Gas=", gas, "T=", T, "C", "kh=", kd

    ! Get and print available gases
    heavywater = 0
    ngas = iapws_g704_ngases(heavywater)
    gases_list => null()
    gases_list => iapws_g704_gases(heavywater)
    gases_str => iapws_g704_gases2(heavywater)
    print *, "Gases in H2O: ", ngas
    print *, gases_str
    do i=1, ngas
        print *, gases_list(i)%gas
    enddo
    
    heavywater = 1
    ngas = iapws_g704_ngases(heavywater)
    gases_list => null()
    gases_list => iapws_g704_gases(heavywater)
    gases_str => iapws_g704_gases2(heavywater)
    print *, "Gases in D2O: ", ngas
    print *, gases_str
    do i=1, ngas
        print *, gases_list(i)%gas
    enddo

end program