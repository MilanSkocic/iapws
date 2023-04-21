program example_in_f
    use iso_fortran_env
    use iapws
    implicit none
    real(real64) :: kh
    character(len=5) :: gas = "O2"
    character(len=5) :: solvent = "H2O"
    real(real64) :: T = 25.0d0

    kh = iapws_kh(T, gas, solvent)
    print "(A10, 1X, A10, 1X, A2, F10.1, A, 4X, A3, SP, F10.4)", "Gas=", gas, "T=", T, "C", "kh=", kh

end program