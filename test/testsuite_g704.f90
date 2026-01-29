module testsuite_g704
    use stdlib_kinds, only: dp, int32
    use testdrive, only : new_unittest, unittest_type, error_type, check
    use iapws
    implicit none
    private
    
    public :: collect_suite_g704

contains

subroutine collect_suite_g704(testsuite)
    implicit none
    type(unittest_type), allocatable, intent(out) :: testsuite(:)
    testsuite = [new_unittest("ngases in H2O", test_ngases_H2O),&
                 new_unittest("ngases in D2O", test_ngases_D2O),&
                 new_unittest("gases in H2O", test_gases_H2O),&
                 new_unittest("gases in D2O", test_gases_D2O),&
                 new_unittest("gases2 in H2O", test_gases2_H2O),&
                 new_unittest("gases2 in D2O", test_gases2_D2O),&
                 new_unittest("kh in H2O", test_kh_H2O),&
                 new_unittest("kh in D2O", test_kh_D2O),&
                 new_unittest("kd in H2O", test_kd_H2O),&
                 new_unittest("kd in D2O", test_kd_D2O)]
end subroutine

subroutine test_ngases_H2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: value, expected
    
    expected = 14
    value = ngases(0)

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_ngases_D2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    integer(int32) :: value, expected
    
    expected = 7
    value = ngases(1)

    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_gases_H2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    character(len=5) :: value, expected
    type(gas_type), pointer :: gases_list(:)
    integer(int32), parameter :: n = 14
    integer(int32) :: i
    
    character(len=5) :: expected_gases(n) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
    
    gases_list => gases(0)
    
    do i=1, n
        value = gases_list(i)%gas
        expected = expected_gases(i)
        call check(error, value, expected)
        if (allocated(error)) return
    enddo
end subroutine

subroutine test_gases_D2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    character(len=5) :: value, expected
    type(gas_type), pointer :: gases_list(:)
    integer(int32), parameter :: n = 7
    integer(int32) :: i
    
    character(len=5) :: expected_gases(n) = &
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
    
    gases_list => gases(1)
    
    do i=1, n
        value = gases_list(i)%gas
        expected = expected_gases(i)
        call check(error, value, expected)
        if (allocated(error)) return
    enddo
end subroutine

subroutine test_gases2_H2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 

    character(len=*), parameter :: expected = "He,Ne,Ar,Kr,Xe,H2,N2,O2,CO,CO2,H2S,CH4,C2H6,SF6"
    character(len=:), pointer :: value 

    value => gases2(0)
    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_gases2_D2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    character(len=*), parameter :: expected = "He,Ne,Ar,Kr,Xe,D2,CH4"
    character(len=:), pointer :: value

    value => gases2(1)
    call check(error, value, expected)
    if (allocated(error)) return
end subroutine

subroutine test_kh_H2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    integer(int32), parameter :: nT = 4
    integer(int32), parameter :: ngas = 14
    character(len=5), parameter :: gases(ngas) =&
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
    integer(int32), parameter :: heavywater = 0
    real(dp) :: k(nT)

    real(dp) :: T_K(nT) = [300.0d0, 400.0d0, 500.0d0, 600.0d0]
    real(dp) :: T_C(nT) 
    real(dp) :: expected_khs(ngas, nT) = &
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
                        3.1445d0, 3.6919d0, 2.6749d0, 1.2402d0], shape=[nT, ngas]))
    integer(int32) :: i, j 
    real(dp) :: value, expected
    
    T_C = T_K - 273.15d0
    
    do i=1, ngas
        call kh(T_K, gases(i), heavywater, k)
        do j=1, nT
            value  = log(k(j)/1000d0)
            expected = expected_khs(i, j)
            call check(error, value, expected, thr=1e-4_dp)
            if (allocated(error)) return
        enddo    
    enddo
end subroutine

subroutine test_kh_D2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    integer(int32), parameter :: nT = 4
    integer(int32), parameter :: ngas = 7
    character(len=5), parameter :: gases(ngas) =&
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
    integer(int32), parameter :: heavywater = 1
    real(dp) :: k(nT)

    real(dp) :: T_K(nT) = [300.0d0, 400.0d0, 500.0d0, 600.0d0]
    real(dp) :: T_C(nT) 
    real(dp) :: expected_khs(ngas, nT) = &
    transpose(reshape([2.5756d0, 2.1215d0, 1.2748d0, -0.0034d0,&
                        2.4421d0, 2.2525d0, 1.5554d0, 0.4664d0,&
                        1.3316d0, 1.7490d0, 1.1312d0, 0.0360d0,&
                        0.8015d0, 1.4702d0, 0.9505d0, -0.0661d0,&
                        0.2750d0, 1.1251d0, 0.4322d0, -0.8730d0,&
                        1.6594d0, 1.6762d0, 0.9042d0, -0.3665d0,&
                        1.3624d0, 1.7968d0, 1.0491d0, -0.2186d0], shape=[nT, ngas]))
    integer(int32) :: i, j 
    real(dp) :: value, expected
    
    T_C = T_K - 273.15d0
    
    do i=1, ngas
        call kh(T_K, gases(i), heavywater, k)
        do j=1, nT
            value  = log(k(j)/1000d0)
            expected = expected_khs(i, j)
            call check(error, value, expected, thr=1e-4_dp)
            if (allocated(error)) return
        enddo    
    enddo
end subroutine

subroutine test_kd_H2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    integer(int32), parameter :: nT = 4
    integer(int32), parameter :: ngas = 14
    character(len=5), parameter :: gases(ngas) =&
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
    integer(int32), parameter :: heavywater = 0
    real(dp) :: k(nT)

    real(dp) :: T_K(nT) = [300.0d0, 400.0d0, 500.0d0, 600.0d0]
    real(dp) :: T_C(nT) 
    real(dp) :: expected_khs(ngas, nT) = &
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
                              15.7067d0, 11.9887d0, 8.5550d0, 4.9599d0], shape=[nT, ngas]))
    integer(int32) :: i, j 
    real(dp) :: value, expected
    
    T_C = T_K - 273.15d0
    
    do i=1, ngas
        call kd(T_K, gases(i), heavywater, k)
        do j=1, nT
            value  = log(k(j))
            expected = expected_khs(i, j)
            call check(error, value, expected, thr=1e-4_dp)
            if (allocated(error)) return
        enddo    
    enddo
end subroutine

subroutine test_kd_D2O(error)
    implicit none
    type(error_type), allocatable, intent(out) :: error 
    
    integer(int32), parameter :: nT = 4
    integer(int32), parameter :: ngas = 7
    character(len=5), parameter :: gases(ngas) =&
    [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
    integer(int32), parameter :: heavywater = 1
    real(dp) :: k(nT)

    real(dp) :: T_K(nT) = [300.0d0, 400.0d0, 500.0d0, 600.0d0]
    real(dp) :: T_C(nT) 
    real(dp) :: expected_khs(ngas, nT) = &
    transpose(reshape([15.2802d0, 10.4217d0, 7.0674d0, 3.9539d0,&
                              15.1473d0, 10.5331d0, 7.3435d0, 4.2800d0,&
                              14.0517d0, 10.0632d0, 6.9498d0,3.9094d0,&
                              13.5042d0, 9.7854d0, 6.8035d0, 3.8160d0,&
                              12.9782d0, 9.4648d0, 6.3074d0, 3.1402d0,&
                              14.3520d0, 10.0178d0, 6.6975d0, 3.5590d0,&
                              14.0646d0, 10.1013d0, 6.9021d0, 3.8126d0], shape=[nT, ngas]))
    integer(int32) :: i, j 
    real(dp) :: value, expected
    
    T_C = T_K - 273.15d0
    
    do i=1, ngas
        call kd(T_K, gases(i), heavywater, k)
        do j=1, nT
            value  = log(k(j))
            expected = expected_khs(i, j)
            call check(error, value, expected, thr=1e-4_dp)
            if (allocated(error)) return
        enddo    
    enddo
end subroutine

end module
