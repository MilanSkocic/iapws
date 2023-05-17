!> @file
!! @brief Module for IAPWS G7_04 

!> @brief Module for IAPWS G7-04
module iapws_g704
    use iso_fortran_env
    use ieee_arithmetic
    implicit none
    private

    !> Absolute temperature in KELVIN 
real(real64), parameter ::  T_KELVIN = 273.15d0 

!! Parameters from IAPWS G7-04 
!> critical temperature of water in K
real(real64), parameter ::  Tc1_H2O = 647.096d0 
!> critical pressure of the water in K
real(real64), parameter ::  pc1_H2O = 22.064d0 
!> critical temperature of heavy water MPa 
real(real64), parameter ::  Tc1_D2O = 643.847d0 
!> critical pressure of heavywater MPa 
real(real64), parameter ::  pc1_D2O = 21.671d0 

!> solvent coefficient for kd in water
real(real64), parameter :: q_H2O = -0.023767d0
!> solvent coefficient for kd in heavywater
real(real64), parameter :: q_D2O = -0.024552d0

type :: abc_t
    character(len=5) :: gas
    real(real64) :: A
    real(real64) :: B
    real(real64) :: C
end type

type :: efgh_t
    character(len=5) :: gas
    real(real64) :: E
    real(real64) :: F
    real(real64) :: G
    real(real64) :: H
end type

!> ai and bi coefficients for water
real(real64), dimension(6, 2), parameter :: aibi_H2O = reshape([&
-7.85951783d0, 1.84408259d0, -11.78664970d0, 22.68074110d0, -15.96187190d0, 1.80122502d0,&
1.000d0, 1.500d0, 3.000d0, 3.500d0, 4.000d0, 7.500d0], [6,2])

!> ai and bi coefficients for heavywater
real(real64), dimension(5, 2), parameter :: aibi_D2O = reshape([&
-7.8966570d0, 24.7330800d0, -27.8112800d0,  9.3559130d0, -9.2200830d0, &
1.00d0, 1.89d0, 2.00d0, 3.00d0, 3.60d0], [5, 2])

!> ABC constants water.
type(abc_t), dimension(14), parameter :: abc_H2O = &
    [abc_t("He", -3.52839d0, 7.12983d0, 4.47770d0),&
     abc_t("Ne", -3.18301d0, 5.31448d0, 5.43774d0),&
     abc_t("Ar", -8.40954d0, 4.29587d0, 10.52779d0),&
     abc_t("Kr", -8.97358d0, 3.61508d0, 11.29963d0),&
     abc_t("Xe", -14.21635d0, 4.00041d0, 15.60999d0),&
     abc_t("H2", -4.73284d0, 6.08954d0, 6.06066d0),&
     abc_t("N2", -9.67578d0, 4.72162d0, 11.70585d0),&
     abc_t("O2", -9.44833d0, 4.43822d0, 11.42005d0),&
     abc_t("CO", -10.52862d0, 5.13259d0, 12.01421d0),&
     abc_t("CO2", -8.55445d0, 4.01195d0, 9.52345d0),&
     abc_t("H2S", -4.51499d0, 5.23538d0, 4.42126d0),&
     abc_t("CH4", -10.44708d0, 4.66491d0, 12.12986d0),&
     abc_t("C2H6", -19.67563d0, 4.51222d0, 20.62567d0),&
     abc_t("SF6", -16.56118d0, 2.15289d0, 20.35440d0)]

!> ABC constants for heavywater
type(abc_t), dimension(7), parameter :: abc_D2O = &
    [abc_t("He", -0.72643d0, 7.02134d0, 2.04433d0),&
     abc_t("Ne", -0.91999d0, 5.65327d0, 3.17247d0),&
     abc_t("Ar", -7.17725d0, 4.48177d0, 9.31509d0),&
     abc_t("Kr", -8.47059d0, 3.91580d0, 10.69433d0),&
     abc_t("Xe", -14.46485d0, 4.42330d0, 15.60919d0),&
     abc_t("D2", -5.33843d0, 6.15723d0, 6.53046d0),&
     abc_t("CH4", -10.01915d0, 4.73368d0, 11.75711d0)]

!> ci and di coefficients for water
real(real64), dimension(6, 2), parameter :: cidi_H2O = reshape([&
1.99274064d0, 1.09965342d0, -0.510839303d0, -1.75493479d0, -45.5170352d0, -6.7469445d5,&
1.0d0/3.0d0, 2.0d0/3.0d0, 5.0d0/3.0d0, 16.0d0/3.0d0, 43.0d0/3.0d0, 110.0d0/3.0d0], [6,2])

!> ci and di coefficients for heavywater
real(real64), dimension(4, 2), parameter :: cidi_D2O = reshape([&
2.7072d0, 0.58662d0, -1.3069d0, -45.663d0, &
0.374d0, 1.45d0, 2.6d0, 12.3d0], [4,2])

!> EFGH constants for water
type(efgh_t), dimension(14), parameter :: efgh_H2O = &
[efgh_t("He", 2267.4082d0, -2.9616d0, -3.2604d0, 7.8819d0),&
 efgh_t("Ne", 2507.3022d0, -38.6955d0, 110.3992d0, -71.9096d0),&
 efgh_t("Ar", 2310.5463d0, -46.7034d0, 160.4066d0, -118.3043d0),&
 efgh_t("Kr", 2276.9722d0, -61.1494d0, 214.0117d0, -159.0407d0),&
 efgh_t("Xe", 2022.8375d0, 16.7913d0, -61.2401d0, 41.9236d0),&
 efgh_t("H2", 2286.4159d0, 11.3397d0, -70.7279d0, 63.0631d0),&
 efgh_t("N2", 2388.8777d0, -14.9593d0, 42.0179d0, -29.4396d0),&
 efgh_t("O2", 2305.0674d0, -11.3240d0, 25.3224d0, -15.6449d0),&
 efgh_t("CO", 2346.2291d0, -57.6317d0, 204.5324d0, -152.6377d0),&
 efgh_t("CO2", 1672.9376d0, 28.1751d0, -112.4619d0, 85.3807d0),&
 efgh_t("H2S", 1319.1205d0, 14.1571d0, -46.8361d0, 33.2266d0),&
 efgh_t("CH4", 2215.6977d0, -0.1089d0, -6.6240d0, 4.6789d0),&
 efgh_t("C2H6", 2143.8121d0, 6.8859d0, -12.6084d0, 0.0d0),&
 efgh_t("SF6", 2871.7265d0, -66.7556d0, 229.7191d0, -172.7400d0)]

 !> EFGH constants for heavywater
type(efgh_t), dimension(7), parameter :: efgh_D2O = &
[efgh_t("He", 2293.2474d0, -54.7707d0, 194.2924d0, -142.1257), &
 efgh_t("Ne", 2439.6677d0, -93.4934d0, 330.7783d0, -243.0100d0),&
 efgh_t("Ar", 2269.2352d0, -53.6321d0, 191.8421d0, -143.7659d0),&
 efgh_t("Kr", 2250.3857d0, -42.0835d0, 140.7656d0, -102.7592d0),&
 efgh_t("Xe", 2038.3656d0, 68.1228d0, -271.3390d0, 207.7984d0),& 
 efgh_t("D2", 2141.3214d0, -1.9696d0, 1.6136d0, 0.0d0),&
 efgh_t("CH4", 2216.0181d0, -40.7666d0, 152.5778d0, -117.7430d0)] 

public :: iapws_g704_kh

contains

!> @brief Find the index of the gas in the ABC table.
!! @param[in] gas Gas.
!! @param[in] abc ABC table.
pure function findgas_abc(gas, abc)result(value)
    implicit none
    !! arguments
    character(len=*), intent(in) :: gas
    type(abc_t), dimension(:), intent(in) :: abc
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

!> @brief Find the index of the gas in the ABC table.
!! @param[in] gas Gas.
!! @param[in] efgh ABC table.
pure function findgas_efgh(gas, efgh)result(value)
    implicit none
    !! arguments
    character(len=*), intent(in) :: gas
    type(efgh_t), dimension(:), intent(in) :: efgh
    !! returns
    integer(int32) :: value
    !! local variables
    integer(int32) :: i

    value = 0

    do i=1, size(efgh)
        if(trim(gas) .eq. efgh(i)%gas)then
            value = i
            exit
        endif
    end do
end function

pure elemental function f_p1star_H2O(T)result(value)
    implicit none
    !! arguments
    real(real64), intent(in) :: T
    !! return
    real(real64) :: value
    !! variables
    real(real64) :: Tr
    real(real64) :: tau

    Tr = (T+T_KELVIN)/Tc1_H2O
    tau = 1 - Tr
    value = exp(1/(Tr) * sum(aibi_H2O(:,1)*tau**(aibi_H2O(:,2)))) * pc1_H2O
end function

pure elemental function f_p1star_D2O(T)result(value)
    implicit none
    !! arguments
    real(real64), intent(in) :: T
    !! return
    real(real64) :: value
    !! variables
    real(real64) :: Tr
    real(real64) :: tau

    Tr = (T+T_KELVIN)/Tc1_D2O
    tau = 1 - Tr
    value = exp(1/(Tr) * sum(aibi_D2O(:,1)*tau**(aibi_D2O(:,2)))) * pc1_D2O
end function

pure elemental function f_kh_p1star_H2O(T, abc)result(value)
    !! arguments
    real(real64), intent(in) :: T
    type(abc_t), intent(in) :: abc
    !! return 
    real(real64) :: value
    !! variables
    real(real64) :: Tr
    real(real64) :: tau

    Tr = (T+T_KELVIN)/Tc1_H2O
    tau = 1 - Tr
    value = exp(abc%A/Tr + abc%B*(tau**0.355d0)/Tr + abc%C*exp(tau)*Tr**(-0.41d0))
end function

pure elemental function f_kh_p1star_D2O(T, abc)result(value)
    !! arguments
    real(real64), intent(in) :: T
    type(abc_t), intent(in) :: abc
    !! return 
    real(real64) :: value
    !! variables
    real(real64) :: Tr
    real(real64) :: tau

    Tr = (T+T_KELVIN)/Tc1_D2O
    tau = 1 - Tr
    value = exp(abc%A/Tr + abc%B*(tau**0.355d0)/Tr + abc%C*exp(tau)*Tr**(-0.41d0))
end function


!> @brief Compute the henry constant for a given temperature and gas in water.
!! @param[in] T Temperature in °C.
!! @param[in] abc ABC parameters.
!! @return kh Henry constant. NaN if gas not found.
pure elemental function iapws_g704_kh_H2O(T, abc)result(value)
    implicit none
    !! arguments
    real(real64), intent(in) :: T
    type(abc_t), intent(in) :: abc
    !! returns
    real(real64) :: value
    value = f_kh_p1star_H2O(T, abc) * f_p1star_H2O(T)
end function

!> @brief Compute the henry constant for a given temperature and gas in heavywater.
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @return kh Henry constant. NaN if gas not found.
pure elemental function iapws_g704_kh_D2O(T, abc)result(value)
    implicit none
    !! arguments
    real(real64), intent(in) :: T
    type(abc_t), intent(in) :: abc
    !! returns
    real(real64) :: value
    value = f_kh_p1star_D2O(T, abc) * f_p1star_D2O(T)
end function

!> @brief Compute the henry constant for a given temperature and gas in solvent 
!! @param[in] T Temperature in °C as 1d-array.
!! @param[in] gas Gas.
!! @param[in] heavywtaer Flag if D2O (true) is used or H2O(false).
!! @param[out] k Henry constant as 1d-array. Filled with NaNs if gas not found.
pure subroutine iapws_g704_kh(T, gas, heavywater, k)
    implicit none
    !! arguments
    real(real64), intent(in) :: T(:)
    character(len=*), intent(in) :: gas
    logical, intent(in) :: heavywater
    real(real64), intent(out) :: k(:)
    !! variables
    integer(int32) :: i

    if(heavywater .eqv. .true.)then
        i = findgas_abc(gas, abc_D2O)
        k =  iapws_g704_kh_D2O(T, abc_D2O(i))
    else
        i = findgas_abc(gas, abc_H2O)
        k = iapws_g704_kh_H2O(T, abc_H2O(i))
    endif

end subroutine

!> @brief Compute the vapor-liquid constant kd of a given gas.
!! @param[in] T_K Temperature in K.
!! @param[in] Tc1 Critical temperature.
!! @param[in] q solvent coefficient
!! @param[in] gas_efgh abc parameters of gas
!! @param[in] cidi ai and bi coefficients of a solvent.
!! @return kd Vapor-liquid constant.
pure function iapws_g704_kd(T_K, Tc1, q, gas_efgh, cidi) result(value)
    implicit none
    !! arguments 
    real(real64), intent(in) :: T_K
    real(real64), intent(in) :: Tc1
    real(real64), intent(in) :: q
    type(efgh_t), intent(in) :: gas_efgh
    real(real64), intent(in), dimension(:,:) :: cidi
    !! returns
    real(real64) :: value
    
    !! local variables
    real(real64) :: Tr
    real(real64) :: tau
    real(real64) :: ft
    real(real64) :: p1
    real(real64) :: p2
    real(real64) :: p3
    real(real64) :: p4
    
    Tr = T_K/Tc1
    tau  = 1-Tr
    
    ft = 0.0
    ft = sum(cidi(:,1) * tau**(cidi(:,2)))

    p1 = q*gas_efgh%F
    p2 = gas_efgh%E/T_K*ft
    p3 = (gas_efgh%F + gas_efgh%G*tau**(2.0d0/3.0d0) + gas_efgh%H*tau)
    p4 = exp((273.15d0 - T_K)/100.0d0)

    value = exp(p1 + p2 + p3 * p4)

end function

!> @brief Compute the kd constant for a given temperature and gas in water.
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @return kd Vapor-liquid constant. NaN if gas not found.
pure function iapws_g704_kd_H2O(T, gas)result(value)
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
    i = findgas_efgh(gas, efgh_H2O)

    if(i==0)then
        value = ieee_value(1.0d0, ieee_quiet_nan)
    else
        value = iapws_g704_kd(T_K, Tc1_H2O, q_H2O, efgh_H2O(i), cidi_H2O)
    endif
end function

!> @brief Compute the kd constant for a given temperature and gas in heavywater.
!! @param[in] T Temperature in °C.
!! @param[in] gas Gas.
!! @return kd Vapor-liquid constant. NaN if gas not found.
pure function iapws_g704_kd_D2O(T, gas)result(value)
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
    i = findgas_efgh(gas, efgh_D2O)

    if(i==0)then
        value = ieee_value(1.0d0, ieee_quiet_nan)
    else
        value = iapws_g704_kd(T_K, Tc1_D2O, q_D2O, efgh_D2O(i), cidi_D2O)
    endif
end function

end module