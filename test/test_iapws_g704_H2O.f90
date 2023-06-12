program test_iapws_g704_H2O
    use iso_fortran_env
    use iapws_g704
    implicit none
    
    integer(int32), parameter :: ngas = 14
    integer(int32), parameter :: nT = 4
    character(len=5) :: gases(ngas)
    real(real64) :: T_K(nT) 
    real(real64) :: T_C(nT)
    real(real64) :: kh(nT)
    real(real64) :: kd(nT)
    real(real64) :: diff(nT)
    integer(int32) :: i, j
    integer(int32) :: D2O = 0


! data copied directly from PDF of the paper
! Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
! in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
real(real64) :: ref_kh(ngas,nT) = &
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

! data copied directly from PDF of the paper
! Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
! in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
real(real64) :: ref_kd(ngas, nT) = &
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
gases = [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
T_K = [300.0d0, 400.0d0, 500.0d0, 600.0d0]

print "(A)", "***** F Test kH in water *****"
print "(A3, 4F23.0)", "Gas", T_K

do i=1, ngas
    T_C = T_K - 273.15
    call iapws_g704_kh(T_C, gases(i), D2O, kh)
    kh = log(kh/1000d0)
    diff = kh(:) - ref_kh(i,:)
    diff = roundn(diff, 4)
    print "(A5,SP, 4F23.4)", gases(i), kh
    print "(A5, SP, 4F23.4)", gases(i), ref_kh(i, :)
    print "(A5,SP, 4F23.4)", gases(i), diff
    print *, " "
    do j=1, nT
        if(diff(j) /= 0.0d0)then
            print "(A, A5, A, F4.0)", "Error for ", gases(i), " at ", T_K(j)
            stop 1
        endif
    enddo
enddo

print "(A)", "***** F Test kd in water *****"
print "(A3, 4F23.0)", "Gas", T_K

do i=1, ngas
    T_C = T_K - 273.15
    call iapws_g704_kd(T_C, gases(i), D2O, kd)
    kd = log(kd)
    diff = kd(:) - ref_kd(i,:)
    diff = roundn(diff, 4)
    print "(A5, SP, 4F23.4)", gases(i), kd
    print "(A5, SP, 4F23.4)", gases(i), ref_kd(i, :)
    print "(A5, SP, 4F23.4)", gases(i), diff
    print *, " "
    do j=1, nT
        if(diff(j) /= 0.0d0)then
            print "(A, A5, A, F4.0)", "Error for ", gases(i), " at ", T_K(j)
            stop 1
        endif
    enddo
enddo

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

end program