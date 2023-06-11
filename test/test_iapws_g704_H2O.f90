program test_iapws_g704_H2O
    use iso_fortran_env
    use iapws_g704
    implicit none
    
    real(real64) :: T_C;
    real(real64) :: kh = 0.0
    real(real64) :: kd = 0.0
    integer(int32) :: D2O = 0
    real(real64) :: diff
    integer(int32) :: i, j
    integer(int32) :: ngas = 14
    integer(int32) :: nT = 4
    character(len=5) :: gases(14)
    real(real64) :: T_K(4) 


! data copied directly from PDF of the paper
! Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
! in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
real(real64) :: ref_kh(14,4) = transpose(reshape([2.6576d0, 2.1660d0, 1.1973d0, -0.1993d0, &
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
                    3.1445d0, 3.6919d0, 2.6749d0, 1.2402d0], shape=[4, 14]))

gases = [character(len=5) :: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
T_K = [300.0d0, 400.0d0, 500.0d0, 600.0d0]


print "(A)", "***** F Test kH in water *****"
print "(A5, 4F23.0)", "Gas", T_K

do j=1, ngas
    do i=1, nT
        T_C = T_K(i) - 273.15
    enddo

enddo


contains

pure function roundn(x, n)result(r)
    implicit none
    real(real64), intent(in) :: x
    integer(int32), intent(in) :: n
    real(real64) :: r
    real(real64) :: fac

    fac = 10**n
    r = nint(x*fac, kind=kind(x)) / fac

end function

end program