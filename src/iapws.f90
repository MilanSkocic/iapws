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

public :: iapws_kh_water, iapws_kh_heavywater, iapws_kh

contains

!> @brief Compute the henry constante for a given temperature and gas in water.
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[out] kh Henry constante in mole fraction per GPa. NaN if status > 0.
!! @param[out] status 0: no error, 1: gas not found, 2: T out of bounds.
pure subroutine iapws_kh_water(T, gas, kh, status)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    real(real64), intent(out) :: kh
    integer(int32), intent(out) :: status !! 0: no error, 1: gas not found, 2: T out of bounds

    !! local variables
    real(real64) :: T_K
    integer(int32) :: i
    type(iapws_G7_04_t_abc) :: gas_abc

    T_K = T + T_KELVIN
    status = 0

    do i=1, size(iapws_G7_04_abc_water)
        if(trim(gas) .eq. iapws_G7_04_abc_water(i)%gas)then
            gas_abc = iapws_G7_04_abc_water(i)
            if((T_K < gas_abc%Tmin) .or. (T_K > gas_abc%Tmax))then
                status = 2
            endif
            exit
        else
            status = 1
        endif
    end do


    if(status > 0)then
        kh = ieee_value(1.0d0, ieee_quiet_nan)
    else
        kh = iapws_G7_04_kh(T_K, iapws_G7_04_Tc1_water, iapws_G7_04_pc1_water, gas_abc, iapws_G7_04_aibi_water)
    endif
end subroutine

!> @brief Compute the henry constante for a given temperature and gas in heavywater.
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @param[out] kh Henry constante in mole fraction per GPa. NaN if status > 0.
!! @param[out] status 0: no error, 1: gas not found, 2: T out of bounds.
pure subroutine iapws_kh_heavywater(T, gas, kh, status)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    real(real64), intent(out) :: kh
    integer(int32), intent(out) :: status !! 0: no error, 1: gas not found, 2: T out of bounds

    !! local variables
    real(real64) :: T_K
    integer(int32) :: i
    type(iapws_G7_04_t_abc) :: gas_abc

    T_K = T + T_KELVIN
    status = 0

    do i=1, size(iapws_G7_04_abc_water)
        if(trim(gas) .eq. iapws_G7_04_abc_heavywater(i)%gas)then
            gas_abc = iapws_G7_04_abc_heavywater(i)
            if((T_K < gas_abc%Tmin) .or. (T_K > gas_abc%Tmax))then
                status = 2
            endif
            exit
        else
            status = 1
        endif
    end do

    if(status > 0)then
        kh = ieee_value(1.0d0, ieee_quiet_nan)
    else
        kh = iapws_G7_04_kh(T_K, iapws_G7_04_Tc1_heavywater, &
                                 iapws_G7_04_pc1_heavywater, &
                                 gas_abc, &
                                 iapws_G7_04_aibi_heavywater)
    endif
end subroutine


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