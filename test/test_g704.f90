program test_g704
    use iso_fortran_env
    use iapws_g704
    implicit none

    print "(A)", "***** TESTING FORTRAN CODE FOR G704 *****"

    call test_ngases()
    call test_gases()
    call test_gases2()
    call test_kh()

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
    real(real64) :: kd(nT)
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
            if(diff > tiny(0.0d0))then
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
            if(diff > tiny(0.0d0))then
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
end subroutine

end program