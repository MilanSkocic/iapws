!> @file
!! Main module for IAPWS

!> @brief Main module for IAPWS computations
module iapws
    use iso_fortran_env
    use ieee_arithmetic
    use iapws_constants
    use iapws_G7_04
    implicit none
    private

public :: iapws_kh

contains


!> @brief Compute the henry constante for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[in] solvent Solvents: H2O or D2O. Default is H2O.
!! @param[out] kh Henry constante in mole fraction per GPa. NaN if status > 0.
!! @param[out] status 0: no error, 1: gas not found, 2: T out of bounds.
pure subroutine iapws_kh(T, gas, solvent, kh, status)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    character(len=*), intent(in) :: solvent
    real(real64), intent(out) :: kh
    integer(int32), intent(out) :: status !! 0: no error, 1: gas not found, 2: T out of bounds

    if(trim(solvent) .eq. "D20")then
        call iapws_kh_heavywater(T, gas, kh, status)
    else
        call iapws_kh_water(T, gas, kh, status)
    endif

end subroutine

end module