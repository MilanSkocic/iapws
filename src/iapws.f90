!> @file
!! Main module for IAPWS

!> @brief Main module for IAPWS computations
module iapws
    use iso_fortran_env
    use ieee_arithmetic
    use iapwsG704
    implicit none
    private

public :: iapws_kh, iapws_kd

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

!> @brief Compute the vapor-liquid constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @return kd Vapor-liquid constant. NaN if gas not found.
pure function iapws_kd(T, gas, solvent)result(value)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    character(len=*), intent(in) :: solvent
    !! returns
    real(real64) :: value

    if(trim(solvent) .eq. "D2O")then
        value =  iapwsG704_kd_heavywater(T, gas)
    else
        value = iapwsG704_kd_water(T, gas)
    endif

end function
end module