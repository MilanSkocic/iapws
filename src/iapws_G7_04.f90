!> @file
!! 

!> @brief Parameters for IAPWS G7-04
module iapws_G7_04
    use iso_fortran_env
    use ieee_arithmetic
    use iapws_constants
    implicit none
    private

!! Parameters from IAPWS G7-04 
!> critical temperature of water in K
real(real64), parameter ::  iapws_G7_04_Tc1_water = 647.096d0 
!> critical pressure of the water in K
real(real64), parameter ::  iapws_G7_04_pc1_water = 22.064d0 
!> critical temperature of heavy water MPa 
real(real64), parameter ::  iapws_G7_04_Tc1_heavywater = 643.847d0 
!> critical pressure of heavywater MPa 
real(real64), parameter ::  iapws_G7_04_pc1_heavywater = 21.671d0 

type :: iapws_G7_04_t_abc
    character(len=5) :: gas
    real(real64) :: A
    real(real64) :: B
    real(real64) :: C
    real(real64) :: Tmin
    real(real64) :: Tmax
    real(real64) :: Mgas
    real(real64) :: Ms
end type

!> ai and bi coefficients for water
real(real64), dimension(6, 2), parameter :: iapws_G7_04_aibi_water = reshape([&
-7.85951783d0, 1.84408259d0, -11.78664970d0, 22.68074110d0, -15.96187190d0, 1.80122502d0,&
1.000d0, 1.500d0, 3.000d0, 3.500d0, 4.000d0, 7.500d0], [6,2])

!> ai and bi coefficients for heavywater
real(real64), dimension(5, 2), parameter :: iapws_G7_04_aibi_heavywater = reshape([&
-7.8966570d0, 24.7330800d0, -27.8112800d0,  9.3559130d0, -9.2200830d0, &
1.00d0, 1.89d0, 2.00d0, 3.00d0, 3.60d0], [5, 2])

!> ABC constants water.
type(iapws_G7_04_t_abc), dimension(14), parameter :: iapws_G7_04_abc_water = &
    [iapws_G7_04_t_abc("He", -3.52839d0, 7.12983d0, 4.47770d0, 273.21d0, 553.18d0, M_He, M_water),&
     iapws_G7_04_t_abc("Ne", -3.18301d0, 5.31448d0, 5.43774d0, 273.20d0, 543.36d0, M_Ne, M_water),&
     iapws_G7_04_t_abc("Ar", -8.40954d0, 4.29587d0, 10.52779d0, 273.19d0, 568.36d0, M_Ar, M_water),&
     iapws_G7_04_t_abc("Kr", -8.97358d0, 3.61508d0, 11.29963d0, 273.19d0, 525.56d0, M_Kr, M_water),&
     iapws_G7_04_t_abc("Xe", -14.21635d0, 4.00041d0, 15.60999d0, 273.22d0, 574.85d0, M_Xe, M_water),&
     iapws_G7_04_t_abc("H2", -4.73284d0, 6.08954d0, 6.06066d0, 273.15d0, 636.09d0, M_H2, M_water),&
     iapws_G7_04_t_abc("N2", -9.67578d0, 4.72162d0, 11.70585d0, 278.12d0, 636.46d0, M_N2, M_water),&
     iapws_G7_04_t_abc("O2", -9.44833d0, 4.43822d0, 11.42005d0, 274.15d0, 616.52d0, M_O2, M_water),&
     iapws_G7_04_t_abc("CO", -10.52862d0, 5.13259d0, 12.01421d0, 278.15d0, 588.67d0, M_CO, M_water),&
     iapws_G7_04_t_abc("CO2", -8.55445d0, 4.01195d0, 9.52345d0, 274.19d0, 642.66d0, M_CO2, M_water),&
     iapws_G7_04_t_abc("H2S", -4.51499d0, 5.23538d0, 4.42126d0, 273.15d0, 533.09d0, M_H2S, M_water),&
     iapws_G7_04_t_abc("CH4", -10.44708d0, 4.66491d0, 12.12986d0, 275.46d0, 633.11d0, M_CH4, M_water),&
     iapws_G7_04_t_abc("C2H6", -19.67563d0, 4.51222d0, 20.62567d0, 275.44d0, 473.46d0, M_C2H6, M_water),&
     iapws_G7_04_t_abc("SF6", -16.56118d0, 2.15289d0, 20.35440d0, 283.14d0, 505.55d0, M_SF6, M_water)]

!> ABC constants for heavywater
type(iapws_G7_04_t_abc), dimension(7), parameter :: iapws_G7_04_abc_heavywater = &
    [iapws_G7_04_t_abc("He", -0.72643d0, 7.02134d0, 2.04433d0, 288.15d0, 553.18d0, M_He, M_heavywater),&
     iapws_G7_04_t_abc("Ne", -0.91999d0, 5.65327d0, 3.17247d0, 288.18d0, 549.96d0, M_Ne, M_heavywater),&
     iapws_G7_04_t_abc("Ar", -7.17725d0, 4.48177d0, 9.31509d0, 288.30d0, 583.76d0, M_Ar, M_heavywater),&
     iapws_G7_04_t_abc("Kr", -8.47059d0, 3.91580d0, 10.69433d0, 288.19d0, 523.06d0, M_Kr, M_heavywater),&
     iapws_G7_04_t_abc("Xe", -14.46485d0, 4.42330d0, 15.60919d0, 295.39d0, 574.85d0, M_Xe, M_heavywater),&
     iapws_G7_04_t_abc("D2", -5.33843d0, 6.15723d0, 6.53046d0, 288.17d0, 581.00d0, M_D2, M_heavywater),&
     iapws_G7_04_t_abc("CH4", -10.01915d0, 4.73368d0, 11.75711d0, 288.16d0, 517.46d0, M_CH4, M_heavywater)]

public :: iapws_kh_water, iapws_kh_heavywater 

contains

!> @brief Compute the henry constant of a given gas.
!! @param[in] ix Gas index for which the computation has to be performed.
!! @param[in] T_K Temperature in K.
!! @param[in] Tc1 Critical temperature.
!! @param[in] pc1 Critical pressure.
!! @param[in] gas_abc abc parameters of gas
!! @param[in] aibi ai and bi coefficients of a solvent.
!! @return kH Henry constant in mole fraction per GPa.
pure function iapws_G7_04_kh(T_K, Tc1, pc1, gas_abc, aibi) result(kh)
    implicit none
    !! arguments 
    real(real64), intent(in) :: T_K
    real(real64), intent(in) :: Tc1
    real(real64), intent(in) :: pc1
    type(iapws_G7_04_t_abc), intent(in) :: gas_abc
    real(real64), intent(in), dimension(:,:) :: aibi
    !! returns
    real(real64) :: kh
    
    !! local variables
    real(real64) :: Tr
    real(real64) :: tau
    real(real64) :: ln_kH_pstar
    real(real64) :: res
    real(real64) :: ln_pstar_pcl
    real(real64) :: pstar
    
    Tr = T_K/Tc1
    tau  = 1-Tr
    ln_kH_pstar = gas_abc%A/Tr + gas_abc%B*(tau**0.355)/Tr + gas_abc%C*exp(tau)*Tr**(-0.41)
    
    res = 0.0
    res = sum(aibi(:,1) * tau**(aibi(:,2)))

    ln_pstar_pcl = 1/Tr * res
    pstar = exp(ln_pstar_pcl)*pc1 !! MPa
    kH = exp(ln_kH_pstar)*pstar/1000.0
end function

!> @brief Compute the solubility constant of a given gas.
!! @param[in] ix Gas index for which the computation has to be performed.
!! @param[in] T_K Temperature in K.
!! @param[in] Tc1 Critical temperature.
!! @param[in] pc1 Critical pressure.
!! @param[in] gas_abc abc parameters of gas
!! @param[in] aibi ai and bi coefficients of a solvent.
!! @return Scm3 Solubility constant in cm3.kg-1.bar-1.
pure function iapws_G7_04_Scm3(T_K, Tc1, pc1, gas_abc, aibi) result(Scm3)
    implicit none
    !! arguments 
    real(real64), intent(in) :: T_K
    real(real64), intent(in) :: Tc1
    real(real64), intent(in) :: pc1
    type(iapws_G7_04_t_abc), intent(in) :: gas_abc
    real(real64), intent(in), dimension(:,:) :: aibi
    !! returns
    real(real64) :: Scm3

    !! local variables
    real(real64):: kh

    kh = iapws_G7_04_kh(T_K, Tc1, pc1, gas_abc, aibi)
    Scm3 = (1/(kh*1.0d4)) * Vm / (gas_abc%Ms*1.0d-3)

end function

!> @brief Compute the solubility constant of a given gas.
!! @param[in] ix Gas index for which the computation has to be performed.
!! @param[in] T_K Temperature in K.
!! @param[in] Tc1 Critical temperature.
!! @param[in] pc1 Critical pressure.
!! @param[in] gas_abc abc parameters of gas
!! @param[in] aibi ai and bi coefficients of a solvent.
!! @return Scm3 Solubility constant in ppm.
pure function iapws_G7_04_Sppm(T_K, Tc1, pc1, gas_abc, aibi) result(Sppm)
    implicit none
    !! arguments 
    real(real64), intent(in) :: T_K
    real(real64), intent(in) :: Tc1
    real(real64), intent(in) :: pc1
    type(iapws_G7_04_t_abc), intent(in) :: gas_abc
    real(real64), intent(in), dimension(:,:) :: aibi
    !! returns
    real(real64) :: Sppm

    !! local variables
    real(real64):: kh

    kh = iapws_G7_04_kh(T_K, Tc1, pc1, gas_abc, aibi)
    Sppm = (1/(kh*1.0d4)) * gas_abc%Mgas / gas_abc%Ms * 1.0d6

end function

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
    status = 1

    do i=1, size(iapws_G7_04_abc_water)
        if(trim(gas) .eq. iapws_G7_04_abc_water(i)%gas)then
            gas_abc = iapws_G7_04_abc_water(i)
            status = 0
            exit
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
!! @param[out] status 0: no error, 1: gas not found
pure subroutine iapws_kh_heavywater(T, gas, kh, status)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    real(real64), intent(out) :: kh
    integer(int32), intent(out) :: status !! 0: no error, 1: gas not found

    !! local variables
    real(real64) :: T_K
    integer(int32) :: i
    type(iapws_G7_04_t_abc) :: gas_abc

    T_K = T + T_KELVIN
    status = 1

    do i=1, size(iapws_G7_04_abc_water)
        if(trim(gas) .eq. iapws_G7_04_abc_heavywater(i)%gas)then
            gas_abc = iapws_G7_04_abc_heavywater(i)
            status = 0
            exit
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



end module