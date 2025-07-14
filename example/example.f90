program example_in_f
    use stdlib_kinds, only: dp, int32
    use iapws
    implicit none
    integer(int32) :: i, ngas
    real(dp) :: T(1), kh_res(1), kd_res(1), wp_res(1), p(1)
    real(dp) :: Ts(7), ps(7)
    real(dp) :: x(3), y(3)
    integer(int32) :: r(3)
    character(len=1) :: s(3)
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
    T(1) = 25.0_dp + 273.15_dp
    call kh(T, gas, heavywater, kh_res)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F10.4)", "Gas=", gas, "T=", T, "K", "kh=", kh_res
    
    call kd(T, gas, heavywater, kd_res)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F15.4)", "Gas=", gas, "T=", T, "K", "kh=", kd_res

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
    Ts(:) = [-1.0_dp, 25.0_dp, 100.0_dp, 200.0_dp, 300.0_dp, 360.0_dp, 374.0_dp]
    Ts(:) = Ts(:) + 273.15_dp
    call psat(Ts, ps)

    do i=1, size(Ts)
        print "(SP, F23.3, A3, 4X, F23.3, A3)", Ts(i), "K", ps(i), "MPa"
    end do 

    ! Compute Ts from ps
    call Tsat(ps, Ts)
    do i=1, size(Ts)
        print "(SP, F23.3, A3, 4X, F23.3, A3)", Ts(i), "K", ps(i), "MPa"
    end do 

    ! Compute water properties at 280°C/8 Mpa
    p(1) = 8.0_dp
    T(1) = 273.15_dp + 280.0_dp
    call wp(p, T, "v", wp_res)
    print "(A5, F23.16, X, A)", "v(8MPa,280°C)=", wp_res(1)*1000.0_dp, "L/kg"

    ! Compute region and phase
    x = [8.0_dp, 4.0_dp, 6.0_dp ] 
    y = [553.15_dp, 1200.0_dp, 2000.0_dp]
    call wr(x, y, r)
    call wph(x, y, s)
    print *, r
    print *, s

end program
