program test_g704
    use iso_fortran_env
    use iapws_g704
    implicit none

    print "(A)", "***** TESTING FORTRAN CODE FOR G704 *****"

    call test_ngases()
    call test_gases()
    call test_gases2()
    call test_kh()
    call test_kd()

contains

pure elemental function roundn(x, n)result(r)
    implicit none
    real(real64), intent(in) :: x
    integer(int32), intent(in) :: n
    real(real64) :: r
    real(real64) :: fac

    fac = 10**n
    r = nint(x*fac, kind=kind(x)) / fac
end function

 function assertEqual(x1, x2, n)result(r)
    implicit none
    real(real64), intent(in) :: x1
    real(real64), intent(in) :: x2
    integer(int32), intent(in) :: n
    logical :: r

    real(real64) :: fac
    real(real64) :: ix1
    real(real64) :: ix2
    
    fac = 10**n
    ix1 = nint(x1 * fac, kind=kind(n))
    ix2 = nint(x2 * fac, kind=kind(n))
    r = ix1 == ix2


end function

subroutine test_ngases()
    implicit none 

    integer(int32) :: value
    integer(int32) :: expected
    integer(int32) :: diff
    integer(int32) :: heavywater
    
    write(*, "(4X, A)", advance="no") "ngases in water..."
    heavywater = 0;
    expected = 14;
    value = iapws_g704_ngases(heavywater);
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, I0.2, A1, I0.2, A1, I0.2)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
    
    write(*, "(4X, A)", advance="no") "ngases in heavywater..."
    heavywater = 1;
    expected = 7;
    value = iapws_g704_ngases(heavywater);
    diff = value - expected;
    if(diff /= 0)then
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, I0.2, A1, I0.2, A1, I0.2)", advance="yes") value, "/", expected, "/", diff
        stop 1
    else
        write(*, "(A)", advance="yes") "OK"
    endif
end subroutine

subroutine test_gases()
    implicit none
    integer(int32) :: heavywater, i
    type(iapws_g704_gas_t), pointer :: gases_list_H2O(:)
    type(iapws_g704_gas_t), pointer :: gases_list_D2O(:)
    character(len=5) :: expected_gases_H2O(14) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
    character(len=5) :: expected_gases_D2O(7) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
    integer(int32) :: diff_gas_H2O(14)
    integer(int32) :: diff_gas_D2O(7)
    
    write(*, "(4X, A)", advance="no") "gases in water..."
    heavywater = 0
    gases_list_H2O => iapws_g704_gases(heavywater)
    do i=1, 14
        if(gases_list_H2O(i)%gas == expected_gases_H2O(i))then
            diff_gas_H2O(i) = 1
        else
            diff_gas_H2O(i) = 0
        endif
    enddo
    if(sum(diff_gas_H2O)== size(diff_gas_H2O))then
        write(*, "(A)", advance="yes") "OK"
    else
        write(*, "(A)", advance="yes") "Failed"
        do i=1, 14
            write(*, "(4X, A, 4X, A, 4X, L)", advance="yes") &
            gases_list_H2O(i)%gas, expected_gases_H2O(i), diff_gas_H2O(i)
        enddo
        stop 1
    endif
    
    write(*, "(4X, A)", advance="no") "gases in heavywater..."
    heavywater = 1
    gases_list_D2O => iapws_g704_gases(heavywater)
    do i=1, 7
        if(gases_list_D2O(i)%gas == expected_gases_D2O(i))then
            diff_gas_D2O(i) = 1
        else
            diff_gas_D2O(i) = 0
        endif
    enddo
    if(sum(diff_gas_D2O)== size(diff_gas_D2O))then
        write(*, "(A)", advance="yes") "OK"
    else
        write(*, "(A)", advance="yes") "Failed"
        do i=1, 7
            write(*, "(4X, A, 4X, A, 4X, L)", advance="yes") &
            gases_list_D2O(i)%gas, expected_gases_D2O(i), diff_gas_D2O(i)
        enddo
        stop 1
    endif
end subroutine

subroutine test_gases2()
    implicit none
    integer(int32) :: heavywater
    character(len=*), parameter :: expected_gases_str_H2O = "He,Ne,Ar,Kr,Xe,H2,N2,O2,CO,CO2,H2S,CH4,C2H6,SF6"
    character(len=*), parameter :: expected_gases_str_D2O = "He,Ne,Ar,Kr,Xe,D2,CH4"
    character(len=:), pointer :: gases_str

    write(*, "(4X, A)", advance="no") "gases2 in water..."
    heavywater = 0
    gases_str => iapws_g704_gases2(heavywater)
    if(expected_gases_str_H2O == gases_str)then
        write(*, "(A)", advance="yes") "OK"
    else
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, A)", advance="yes") gases_str
        write(*, "(4X, A)", advance="yes") expected_gases_str_H2O
        stop 1
    endif

    write(*, "(4X, A)", advance="no") "gases2 in heavywater..."
    heavywater = 1
    gases_str => iapws_g704_gases2(heavywater)
    if(expected_gases_str_D2O == gases_str)then
        write(*, "(A)", advance="yes") "OK"
    else
        write(*, "(A)", advance="yes") "Failed"
        write(*, "(4X, A)", advance="yes") gases_str
        write(*, "(4X, A)", advance="yes") expected_gases_str_D2O
    endif
end subroutine

subroutine test_kh()
    implicit none

    integer(int32), parameter :: nT = 4
    integer(int32), parameter :: ngas_H2O = 14
    integer(int32), parameter :: ngas_D2O = 7
    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    integer(int32) :: heavywater
    real(real64) :: kh(nT)
    integer(int32) :: i, j
    real(real64) :: T_K(4) = [300.0d0, 400.0d0, 500.0d0, 600.0d0]
    real(real64) :: T_C(4) 
    character(len=5) :: gases_H2O(ngas_H2O) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
    character(len=5) :: gases_D2O(ngas_D2O) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
    
    real(real64) :: ref_kh_H2O(ngas_H2O,nT) = &
    transpose(reshape([2.6576d0, 2.1660d0, 1.1973d0, -0.1993d0, &
                        2.5134d0, 2.3512d0, 1.5952d0, 0.4659d0,&
                        1.4061d0, 1.8079d0, 1.1536d0, 0.0423d0,&
                        0.8210d0, 1.4902d0, 0.9798d0, 0.0006d0,&
                        0.2792d0, 1.1430d0, 0.5033d0, -0.7081d0,&
                        1.9702d0, 1.8464d0, 1.0513d0, -0.1848d0,&
                        2.1716d0, 2.3509d0, 1.4842d0, 0.1647d0,&
                        1.5024d0, 1.8832d0, 1.1630d0, -0.0276d0,&
                        1.7652d0, 1.9939d0, 1.1250d0, -0.2382d0,&
                        -1.7508d0, -0.5450d0, -0.6524d0, -1.3489d0,&
                        -2.8784d0, -1.7083d0, -1.6074d0, -2.1319d0,&
                        1.4034d0, 1.7946d0, 1.0342d0, -0.2209d0,&
                        1.1418d0, 1.8495d0, 0.8274d0, -0.8141d0,&
                        3.1445d0, 3.6919d0, 2.6749d0, 1.2402d0], shape=[nT, ngas_H2O]))
    
    real(real64) :: ref_kh_D2O(ngas_D2O,nT) = &
    transpose(reshape([2.5756d0, 2.1215d0, 1.2748d0, -0.0034d0,&
                        2.4421d0, 2.2525d0, 1.5554d0, 0.4664d0,&
                        1.3316d0, 1.7490d0, 1.1312d0, 0.0360d0,&
                        0.8015d0, 1.4702d0, 0.9505d0, -0.0661d0,&
                        0.2750d0, 1.1251d0, 0.4322d0, -0.8730d0,&
                        1.6594d0, 1.6762d0, 0.9042d0, -0.3665d0,&
                        1.3624d0, 1.7968d0, 1.0491d0, -0.2186d0], shape=[nT, ngas_D2O]))
    T_C = T_K - 273.15d0
    write(*, "(4X, A)", advance="no") "kh in water..."
    heavywater = 0
    do i=1, ngas_H2O
        call iapws_g704_kh(T_C, gases_H2O(i), heavywater, kh)
        do j=1, nT
            value  = log(kh(j)/1000d0)
            expected = ref_kh_H2O(i, j)
            diff = value - expected
            diff = roundn(diff, 4)
            if(.not. assertEqual(diff, 0.0d0, 4))then
                write(*, "(A)", advance="yes") "Failed"
                write(*, "(4X, A, 1X, F7.4, 4X, SP, F7.4, A1, F7.4, A1, F7.4)", advance="yes") &
                gases_H2O(i), T_K(j), value, "/", expected, "/", diff
                stop 1
            endif
        enddo    
    enddo
    write(*, "(A)", advance="yes") "OK"
    
    write(*, "(4X, A)", advance="no") "kh in heavyater..."
    heavywater = 1
    do i=1, ngas_D2O
        call iapws_g704_kh(T_C, gases_D2O(i), heavywater, kh)
        do j=1, nT
            value  = log(kh(j)/1000d0)
            expected = ref_kh_D2O(i, j)
            diff = value - expected
            diff = roundn(diff, 4)
            if(.not. assertEqual(diff, 0.0d0, 4))then
                write(*, "(A)", advance="yes") "Failed"
                write(*, "(4X, A, 1X, F7.4, 4X, SP, F7.4, A1, F7.4, A1, F7.4)", advance="yes") &
                gases_D2O(i), T_K(j), value, "/", expected, "/", diff
                stop 1
            endif
        enddo    
    enddo
    write(*, "(A)", advance="yes") "OK"
end subroutine

subroutine test_kd()
    implicit none

    integer(int32), parameter :: nT = 4
    integer(int32), parameter :: ngas_H2O = 14
    integer(int32), parameter :: ngas_D2O = 7
    real(real64) :: value
    real(real64) :: expected
    real(real64) :: diff
    integer(int32) :: heavywater
    real(real64) :: kd(nT)
    integer(int32) :: i, j
    real(real64) :: T_K(4) = [300.0d0, 400.0d0, 500.0d0, 600.0d0]
    real(real64) :: T_C(4) 
    character(len=5) :: gases_H2O(ngas_H2O) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
    character(len=5) :: gases_D2O(ngas_D2O) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
    
    real(real64) :: ref_kd_H2O(ngas_H2O,nT) = &
    transpose(reshape([15.2250d0, 10.4364d0, 6.9971d0, 3.8019d0,&
                              15.0743d0, 10.6379d0, 7.4116d0, 4.2308d0,&
                              13.9823d0, 10.0558d0, 6.9869d0, 3.9861d0,&
                              13.3968d0, 9.7362d0, 6.8371d0, 3.9654d0,&
                              12.8462d0, 9.4268d0, 6.3639d0, 3.3793d0,&
                              14.5286d0, 10.1484d0, 6.8948d0, 3.7438d0,&
                              14.7334d0, 10.6221d0, 7.2923d0, 4.0333d0,&
                              14.0716d0, 10.1676d0, 6.9979d0, 3.8707d0,&
                              14.3276d0, 10.2573d0, 7.1218d0, 4.0880d0,&
                              10.8043d0, 7.7705d0, 5.2123d0, 2.7293d0,&
                              9.6846d0, 6.5840d0, 4.2781d0, 2.2200d0,&
                              13.9659d0, 10.0819d0, 6.8559d0, 3.7238d0,&
                              13.7063d0, 10.1510d0, 6.8453d0, 3.6493d0,&
                              15.7067d0, 11.9887d0, 8.5550d0, 4.9599d0], shape=[nT, ngas_H2O]))
    
    real(real64) :: ref_kd_D2O(ngas_D2O,nT) = &
    transpose(reshape([15.2802d0, 10.4217d0, 7.0674d0, 3.9539d0,&
                              15.1473d0, 10.5331d0, 7.3435d0, 4.2800d0,&
                              14.0517d0, 10.0632d0, 6.9498d0,3.9094d0,&
                              13.5042d0, 9.7854d0, 6.8035d0, 3.8160d0,&
                              12.9782d0, 9.4648d0, 6.3074d0, 3.1402d0,&
                              14.3520d0, 10.0178d0, 6.6975d0, 3.5590d0,&
                              14.0646d0, 10.1013d0, 6.9021d0, 3.8126d0], shape=[nT, ngas_D2O]))
    T_C = T_K - 273.15d0
    write(*, "(4X, A)", advance="no") "kd in water..."
    heavywater = 0
    do i=1, ngas_H2O
        call iapws_g704_kd(T_C, gases_H2O(i), heavywater, kd)
        do j=1, nT
            value  = log(kd(j))
            expected = ref_kd_H2O(i, j)
            diff = value - expected
            diff = roundn(diff, 4)
            if(.not. assertEqual(diff, 0.0d0, 4))then
                write(*, "(A)", advance="yes") "Failed"
                write(*, "(4X, A, 1X, F8.4, 4X, SP, F8.4, A1, F8.4, A1, F8.4)", advance="yes") &
                gases_H2O(i), T_K(j), value, "/", expected, "/", diff
                stop 1
            endif
        enddo    
    enddo
    write(*, "(A)", advance="yes") "OK"
    
    write(*, "(4X, A)", advance="no") "kd in heavyater..."
    heavywater = 1
    do i=1, ngas_D2O
        call iapws_g704_kd(T_C, gases_D2O(i), heavywater, kd)
        do j=1, nT
            value  = log(kd(j))
            expected = ref_kd_D2O(i, j)
            diff = value - expected
            diff = roundn(diff, 4)
            if(.not. assertEqual(diff, 0.0d0, 4))then
                write(*, "(A)", advance="yes") "Failed"
                write(*, "(4X, A, 1X, F8.4, 4X, SP, F8.4, A1, F8.4, A1, F8.4)", advance="yes") &
                gases_D2O(i), T_K(j), value, "/", expected, "/", diff
                stop 1
            endif
        enddo    
    enddo
    write(*, "(A)", advance="yes") "OK"
end subroutine

end program