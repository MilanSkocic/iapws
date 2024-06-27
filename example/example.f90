program example_in_f
    use stdlib_kinds, only: dp, int32
    use iapws
    implicit none
    integer(int32) :: i, ngas
    real(dp) :: T(1), kh_res(1), kd_res(1)
    real(dp) :: Ts(5), ps(5)
    character(len=2) :: gas = "O2"
    integer(int32) :: heavywater = 0
    type(gas_type), pointer :: gases_list(:)
    character(len=:), pointer :: gases_str
    
    print *, '########################## IAPWS VERSION ##########################'
    print *, "version ", get_version()  

    print *, '########################## IAPWS R2-83 ##########################'
    print "(a, f10.3, a)", "Tc in h2o=", Tc_H2O, " k"
    print "(a, f10.3, a)", "pc in h2o=", pc_H2O, " mpa"
    print "(a, f10.3, a)", "rhoc in h2o=", rhoc_H2O, " kg/m3"
    
    print "(a, f10.3, a)", "Tc in D2O=", Tc_D2O, " k"
    print "(a, f10.3, a)", "pc in D2O=", pc_D2O, " mpa"
    print "(a, f10.3, a)", "rhoc in D2O=", rhoc_D2O, " kg/m3"
    print *, ''

    print *, '########################## IAPWS G7-04 ##########################'
    ! Compute kh and kd in H2O
    T(1) = 25.0d0
    call kh(T, gas, heavywater, kh_res)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F10.4)", "Gas=", gas, "T=", T, "C", "kh=", kh_res
    
    call kd(T, gas, heavywater, kd_res)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F15.4)", "Gas=", gas, "T=", T, "C", "kh=", kd_res

    ! Get and print available gases
    heavywater = 0
    ngas = ngases(heavywater)
    gases_list => null()
    gases_list => gases(heavywater)
    gases_str => gases2(heavywater)
    print *, "Gases in H2O: ", ngas
    print *, gases_str
    do i=1, ngas
        print *, gases_list(i)%gas
    enddo
    
    heavywater = 1
    ngas = ngases(heavywater)
    gases_list => null()
    gases_list => gases(heavywater)
    gases_str => gases2(heavywater)
    print *, "Gases in D2O: ", ngas
    print *, gases_str
    do i=1, ngas
        print *, gases_list(i)%gas
    enddo

    print *, '########################## IAPWS R7-97 ##########################'
    ! Compute ps from Ts.
    Ts(:) = [25.0_dp, 100.0_dp, 200.0_dp, 300.0_dp, 360.0_dp]
    call psat(Ts, ps)

    do i=1, size(Ts)
        print "(SP, F23.3, A3, 4X, F23.3, A3, F23.3, A3)", Ts(i), "°C", ps(i), "MPa", ps(i)*10.0_dp, "bar"
    end do 

end program
