!> @file
!! @brief Module for IAPWS G7_04 

!> @brief Module for IAPWS G7-04
module iapwsG704
    use iso_fortran_env
    use ieee_arithmetic
    implicit none
    private

    !> Absolute temperature in KELVIN 
real(real64), parameter ::  T_KELVIN = 273.15d0 

!! Parameters from IAPWS G7-04 
!> critical temperature of water in K
real(real64), parameter ::  iapwsG704_Tc1_water = 647.096d0 
!> critical pressure of the water in K
real(real64), parameter ::  iapwsG704_pc1_water = 22.064d0 
!> critical temperature of heavy water MPa 
real(real64), parameter ::  iapwsG704_Tc1_heavywater = 643.847d0 
!> critical pressure of heavywater MPa 
real(real64), parameter ::  iapwsG704_pc1_heavywater = 21.671d0 

type :: iapwsG704_t_abc
    character(len=5) :: gas
    real(real64) :: A
    real(real64) :: B
    real(real64) :: C
end type

type :: iapwsG704_t_efgh
    character(len=5) :: gas
    real(real64) :: E
    real(real64) :: F
    real(real64) :: G
    real(real64) :: H
end type

!> ai and bi coefficients for water
real(real64), dimension(6, 2), parameter :: iapwsG704_aibi_water = reshape([&
-7.85951783d0, 1.84408259d0, -11.78664970d0, 22.68074110d0, -15.96187190d0, 1.80122502d0,&
1.000d0, 1.500d0, 3.000d0, 3.500d0, 4.000d0, 7.500d0], [6,2])

!> ai and bi coefficients for heavywater
real(real64), dimension(5, 2), parameter :: iapwsG704_aibi_heavywater = reshape([&
-7.8966570d0, 24.7330800d0, -27.8112800d0,  9.3559130d0, -9.2200830d0, &
1.00d0, 1.89d0, 2.00d0, 3.00d0, 3.60d0], [5, 2])

!> ABC constants water.
type(iapwsG704_t_abc), dimension(14), parameter :: iapwsG704_abc_water = &
    [iapwsG704_t_abc("He", -3.52839d0, 7.12983d0, 4.47770d0),&
     iapwsG704_t_abc("Ne", -3.18301d0, 5.31448d0, 5.43774d0),&
     iapwsG704_t_abc("Ar", -8.40954d0, 4.29587d0, 10.52779d0),&
     iapwsG704_t_abc("Kr", -8.97358d0, 3.61508d0, 11.29963d0),&
     iapwsG704_t_abc("Xe", -14.21635d0, 4.00041d0, 15.60999d0),&
     iapwsG704_t_abc("H2", -4.73284d0, 6.08954d0, 6.06066d0),&
     iapwsG704_t_abc("N2", -9.67578d0, 4.72162d0, 11.70585d0),&
     iapwsG704_t_abc("O2", -9.44833d0, 4.43822d0, 11.42005d0),&
     iapwsG704_t_abc("CO", -10.52862d0, 5.13259d0, 12.01421d0),&
     iapwsG704_t_abc("CO2", -8.55445d0, 4.01195d0, 9.52345d0),&
     iapwsG704_t_abc("H2S", -4.51499d0, 5.23538d0, 4.42126d0),&
     iapwsG704_t_abc("CH4", -10.44708d0, 4.66491d0, 12.12986d0),&
     iapwsG704_t_abc("C2H6", -19.67563d0, 4.51222d0, 20.62567d0),&
     iapwsG704_t_abc("SF6", -16.56118d0, 2.15289d0, 20.35440d0)]

!> ABC constants for heavywater
type(iapwsG704_t_abc), dimension(7), parameter :: iapwsG704_abc_heavywater = &
    [iapwsG704_t_abc("He", -0.72643d0, 7.02134d0, 2.04433d0),&
     iapwsG704_t_abc("Ne", -0.91999d0, 5.65327d0, 3.17247d0),&
     iapwsG704_t_abc("Ar", -7.17725d0, 4.48177d0, 9.31509d0),&
     iapwsG704_t_abc("Kr", -8.47059d0, 3.91580d0, 10.69433d0),&
     iapwsG704_t_abc("Xe", -14.46485d0, 4.42330d0, 15.60919d0),&
     iapwsG704_t_abc("D2", -5.33843d0, 6.15723d0, 6.53046d0),&
     iapwsG704_t_abc("CH4", -10.01915d0, 4.73368d0, 11.75711d0)]

!> ci and di coefficients for water
real(real64), dimension(6, 2), parameter :: iapwsG704_cidi_water = reshape([&
1.99274064d0, 1.09965342d0, -0.510839303d0, -1.75493479d0, -45.5170352d0, 6.7469445d5,&
1.0d0/3.0d0, 2.0d0/3.0d0, 5.0d0/3.0d0, 16.0d0/3.0d0, 43.0d0/3.0d0, 110.0d0/3.0d0], [6,2])

!> ci and di coefficients for heavywater
real(real64), dimension(4, 2), parameter :: iapwsG704_cidi_heavywater = reshape([&
2.7072d0, 0.58662d0, -1.3069d0, -45.663d0, &
0.374d0, 1.45d0, 2.6d0, 12.3d0], [4,2])

!> EFGH constants for water
type(iapwsG704_t_efgh), dimension(2), parameter :: iapwsG704_efgh_water = &
[iapwsG704_t_efgh("He", 2267.4082d0, -2.9616d0, -3.2604d0, 7.8819d0),&
 iapwsG704_t_efgh("Ne", 2507.3022d0, -38.6955d0, 110.3992d0, -71.9096d0)]

 !> EFGH constants for heavywater
type(iapwsG704_t_efgh), dimension(2), parameter :: iapwsG704_efgh_heavywater = &
[iapwsG704_t_efgh("He", 2293.2474d0, -54.7707d0, 194.2924d0, -142.1257d0), &
 iapwsG704_t_efgh("Ne", 2507.3022d0, -38.6955d0, 110.3992d0, -71.9096d0)]

public :: iapwsG704_kh_water, iapwsG704_kh_heavywater 

contains

!> @brief Find the index of the gas in the ABC table.
!! @param[in] gas Gas.
!! @param[in] abc ABC table.
pure function iapwsG704_findgas(gas, abc)result(value)
    implicit none
    !! arguments
    character(len=*), intent(in) :: gas
    type(iapwsG704_t_abc), dimension(:), intent(in) :: abc
    !! returns
    integer(int32) :: value
    !! local variables
    integer(int32) :: i

    value = 0

    do i=1, size(abc)
        if(trim(gas) .eq. abc(i)%gas)then
            value = i
            exit
        endif
    end do
end function

!> @brief Compute the henry constant of a given gas.
!! @param[in] ix Gas index for which the computation has to be performed.
!! @param[in] T_K Temperature in K.
!! @param[in] Tc1 Critical temperature.
!! @param[in] pc1 Critical pressure.
!! @param[in] gas_abc abc parameters of gas
!! @param[in] aibi ai and bi coefficients of a solvent.
!! @return kH Henry constant in mole fraction per GPa.
pure function iapwsG704_kh(T_K, Tc1, pc1, gas_abc, aibi) result(value)
    implicit none
    !! arguments 
    real(real64), intent(in) :: T_K
    real(real64), intent(in) :: Tc1
    real(real64), intent(in) :: pc1
    type(iapwsG704_t_abc), intent(in) :: gas_abc
    real(real64), intent(in), dimension(:,:) :: aibi
    !! returns
    real(real64) :: value
    
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
    value = exp(ln_kH_pstar)*pstar/1000.0
end function

!> @brief Compute the henry constante for a given temperature and gas in water.
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @return kh Henry constante in mole fraction per GPa. NaN if gas not found.
pure function iapwsG704_kh_water(T, gas)result(value)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    !! returns
    real(real64) :: value

    !! local variables
    real(real64) :: T_K
    integer(int32) :: i

    T_K = T + T_KELVIN
    i = iapwsG704_findgas(gas, iapwsG704_abc_water)

    if(i==0)then
        value = ieee_value(1.0d0, ieee_quiet_nan)
    else
        value = iapwsG704_kh(T_K, &
                            iapwsG704_Tc1_water, &
                            iapwsG704_pc1_water, &
                            iapwsG704_abc_water(i), &
                            iapwsG704_aibi_water)
    endif
end function

!> @brief Compute the henry constante for a given temperature and gas in heavywater.
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @return kh Henry constante in mole fraction per GPa. NaN if gas not found.
pure function iapwsG704_kh_heavywater(T, gas)result(value)
    implicit none

    !! arguments
    real(real64), intent(in) :: T
    character(len=*), intent(in) :: gas
    !! returns
    real(real64) :: value

    !! local variables
    real(real64) :: T_K
    integer(int32) :: i

    T_K = T + T_KELVIN
    i = iapwsG704_findgas(gas, iapwsG704_abc_heavywater)

    if(i==0)then
        value = ieee_value(1.0d0, ieee_quiet_nan)
    else
        value = iapwsG704_kh(T_K, &
                            iapwsG704_Tc1_heavywater, &
                            iapwsG704_pc1_heavywater, &
                            iapwsG704_abc_heavywater(i), &
                            iapwsG704_aibi_heavywater)
    endif
end function

!> @brief Compute the vapor-liquid constant of a given gas.
!! @param[in] ix Gas index for which the computation has to be performed.
!! @param[in] T_K Temperature in K.
!! @param[in] Tc1 Critical temperature.
!! @param[in] q solvent coefficient
!! @param[in] gas_abc abc parameters of gas
!! @param[in] cidi ai and bi coefficients of a solvent.
!! @return kH Henry constant in mole fraction per GPa.
pure function iapwsG704_kd(T_K, Tc1, q, gas_efgh, cidi) result(value)
    implicit none
    !! arguments 
    real(real64), intent(in) :: T_K
    real(real64), intent(in) :: Tc1
    real(real64), intent(in) :: q
    type(iapwsG704_t_efgh), intent(in) :: gas_efgh
    real(real64), intent(in), dimension(:,:) :: cidi
    !! returns
    real(real64) :: value
    
    !! local variables
    real(real64) :: Tr
    real(real64) :: tau
    real(real64) :: res
    real(real64) :: p1
    real(real64) :: p2
    real(real64) :: p3
    real(real64) :: p4
    
    Tr = T_K/Tc1
    tau  = 1-Tr
    
    res = 0.0
    res = sum(cidi(:,1) * tau**(cidi(:,2)))

    p1 = q*gas_efgh%F
    p2 = gas_efgh%E/T_K*res
    p3 = (gas_efgh%F + gas_efgh%G*res**(2.0d0/3.0d0) + gas_efgh%H*tau)
    p4 = exp((273.15d0 - T_K)/100.0d0)

    value = p1 + p2 + p3 * p4

end function


end module