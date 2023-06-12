program test_iapws_g704_D2O
    use iso_fortran_env
    use iapws_g704
    implicit none
    
    integer(int32), parameter :: ngas = 7
    integer(int32), parameter :: nT = 4
    character(len=5) :: gases(ngas)
    real(real64) :: T_K(nT) 
    real(real64) :: T_C(nT)
    real(real64) :: kh(nT)
    real(real64) :: kd(nT)
    real(real64) :: diff(nT)
    integer(int32) :: i, j


! data copied directly from PDF of the paper
! Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
! in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
real(real64) :: ref_kh(ngas,nT) = &
transpose(reshape([2.5756d0, 2.1215d0, 1.2748d0, -0.0034d0,&
                    2.4421d0, 2.2525d0, 1.5554d0, 0.4664d0,&
                    1.3316d0, 1.7490d0, 1.1312d0, 0.0360d0,&
                    0.8015d0, 1.4702d0, 0.9505d0, -0.0661d0,&
                    0.2750d0, 1.1251d0, 0.4322d0, -0.8730d0,&
                    1.6594d0, 1.6762d0, 0.9042d0, -0.3665d0,&
                    1.3624d0, 1.7968d0, 1.0491d0, -0.2186d0], shape=[nT, ngas]))

! data copied directly from PDF of the paper
! Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
! in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
real(real64) :: ref_kd(ngas, nT) = &
transpose(reshape([15.2802d0, 10.4217d0, 7.0674d0, 3.9539d0,&
                              15.1473d0, 10.5331d0, 7.3435d0, 4.2800d0,&
                              14.0517d0, 10.0632d0, 6.9498d0,3.9094d0,&
                              13.5042d0, 9.7854d0, 6.8035d0, 3.8160d0,&
                              12.9782d0, 9.4648d0, 6.3074d0, 3.1402d0,&
                              14.3520d0, 10.0178d0, 6.6975d0, 3.5590d0,&
                              14.0646d0, 10.1013d0, 6.9021d0, 3.8126d0], shape=[nT, ngas]))
gases = [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
T_K = [300.0d0, 400.0d0, 500.0d0, 600.0d0]

print "(A)", "***** F Test kH in heavywater *****"
print "(A3, 4F23.0)", "Gas", T_K

do i=1, ngas
    T_C = T_K - 273.15
    call iapws_g704_kh(T_C, gases(i), 1, kh)
    kh = log(kh/1000d0)
    diff = kh(:) - ref_kh(i,:)
    diff = roundn(diff, 4)
    print "(A5, 4F23.4)", gases(i), kh
    print "(A5, 4F23.4)", gases(i), ref_kh(i, :)
    print "(A5, 4F23.4)", gases(i), diff
    print *, " "
    do j=1, nT
        if(diff(j) /= 0.0d0)then
            print "(A, A5, F4.0)", "Error in", gases(i), T_K(j)
            stop 1
        endif
    enddo
enddo

print "(A)", "***** F Test kd in heavywater *****"
print "(A3, 4F23.0)", "Gas", T_K

do i=1, ngas
    T_C = T_K - 273.15
    call iapws_g704_kd(T_C, gases(i), 1, kd)
    kd = log(kd)
    diff = kd(:) - ref_kd(i,:)
    diff = roundn(diff, 4)
    print "(A5, 4F23.4)", gases(i), kd
    print "(A5, 4F23.4)", gases(i), ref_kd(i, :)
    print "(A5, 4F23.4)", gases(i), diff
    print *, " "
    do j=1, nT
        if(diff(j) /= 0.0d0)then
            print "(A, A5, F4.0)", "Error in", gases(i), T_K(j)
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