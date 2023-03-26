!> @file
!! Main module for IAPWS
!! @example example_in_f.f90

!> @brief Main module for IAPWS computations
module iapws
    use iso_fortran_env
    use ieee_arithmetic
    use iapwsG704
    implicit none
    private

public :: iapws_kh, iapws_Scm3, iapws_Sppm

contains

!> @brief Compute the henry constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @return kh Henry constant in mole fraction per GPa. NaN if gas not found.
pure function iapws_kh(T, gas, solvent)result(value)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    character(len=*), intent(in) :: solvent
    !! returns
    real(real64) :: value

    if(trim(solvent) .eq. "D2O")then
        value =  iapwsG704_kh_heavywater(T, gas)
    else
        value = iapwsG704_kh_water(T, gas)
    endif

end function

!> @brief Compute the solubility for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @return Scm3 Solubility constant in cm3.kg-1.bar-1. NaN if gas not found.
pure function iapws_scm3(T, gas, solvent)result(value)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    character(len=*), intent(in) :: solvent
    !! returns
    real(real64) :: value

    if(trim(solvent) .eq. "D2O")then
        value =  iapwsG704_kh_scm3_heavywater(T, gas)
    else
        value = iapwsG704_kh_scm3_water(T, gas)
    endif

end function

!> @brief Compute the solubility for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @return Sppm Solubility constant in ppm. NaN if gas not found.
pure function iapws_sppm(T, gas, solvent)result(value)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    character(len=*), intent(in) :: solvent
    !! returns
    real(real64) :: value

    if(trim(solvent) .eq. "D2O")then
        value =  iapwsG704_kh_sppm_heavywater(T, gas)
    else
        value = iapwsG704_kh_sppm_water(T, gas)
    endif

end function


end module