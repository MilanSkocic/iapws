!> @file
!! Main module for IAPWS
!! @example example_in_f.f90

!> @brief Main module for IAPWS computations
module iapws
    use iso_fortran_env
    use ieee_arithmetic
    use iapws_constants
    use iapws_G7_04
    implicit none
    private

public :: iapws_kh, iapws_Scm3, iapws_Sppm

contains

!> @brief Compute the henry constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @return kh Henry constante in mole fraction per GPa. NaN if gas not found.
pure function iapws_kh(T, gas, solvent)result(kh)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    character(len=*), intent(in) :: solvent
    !! returns
    real(real64) :: kh

    if(trim(solvent) .eq. "D2O")then
        kh =  iapws_G7_04_kh_heavywater(T, gas)
    else
        kh = iapws_G7_04_kh_water(T, gas)
    endif

end function

!> @brief Compute the solubility for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @return Scm3 Solubility constant in cm3.kg-1.bar-1. NaN if gas not found.
pure function iapws_scm3(T, gas, solvent)result(Scm3)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    character(len=*), intent(in) :: solvent
    !! returns
    real(real64) :: Scm3

    if(trim(solvent) .eq. "D2O")then
        Scm3 =  iapws_G7_04_Scm3_heavywater(T, gas)
    else
        Scm3 = iapws_G7_04_Scm3_water(T, gas)
    endif

end function

!> @brief Compute the solubility for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @return Sppm Solubility constant in ppm. NaN if gas not found.
pure function iapws_sppm(T, gas, solvent)result(Sppm)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    character(len=*), intent(in) :: solvent
    !! returns
    real(real64) :: Sppm

    if(trim(solvent) .eq. "D2O")then
        Sppm =  iapws_G7_04_Sppm_heavywater(T, gas)
    else
        Sppm = iapws_G7_04_Sppm_water(T, gas)
    endif

end function
end module