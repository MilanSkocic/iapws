program example_in_f
    use iso_fortran_env
    use iapws
    implicit none
    real(real64) :: kh
    integer(int32) :: status
    character(len=5) :: gas = "He"
    character(len=5) :: solvent = "H2O"
    real(real64) :: T = 26.85d0

    call iapws_kh(T, gas, solvent, kh, status)
    print *, "Gas=", gas, "T=", T, "°C", "kh=", kh

end program