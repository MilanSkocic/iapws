program example_in_f
    use iso_fortran_env
    use iapws
    implicit none
    real(real64) :: kh, Scm3, Sppm
    integer(int32) :: status
    character(len=5) :: gas = "O2"
    character(len=5) :: solvent = "H2O"
    real(real64) :: T = 25.0d0

    kh = iapws_kh(T, gas, solvent)
    print "(A10, X, A10, X, A2, F10.1, A, 4X, A3, SP, F10.4)", "Gas=", gas, "T=", T, "C", "kh=", kh
    Scm3 = iapws_scm3(T, gas, solvent)
    print "(A10, X, A10, X, A2, F10.1, A, 4X, A3, SP, F10.4, A20)", "Gas=", gas, "T=", T, "C", "kh=", Scm3, " cm3.kg-1.bar-1"
    Sppm = iapws_sppm(T, gas, solvent)
    print "(A10, X, A10, X, A2, F10.1, A, 4X, A3, SP, F10.4, A20)", "Gas=", gas, "T=", T, "C", "kh=", Sppm, " ppm.bar-1"

end program