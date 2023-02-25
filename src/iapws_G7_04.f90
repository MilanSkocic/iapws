!> @file
!! 

!> @brief Parameters for IAPWS G7-04
module iapws_G7_04
    use iso_fortran_env
    use iapws_constants
    implicit none


!! Parameters from IAPWS G7-04 
!> Absolute temperature in KELVIN 
real(real64), parameter ::  T_KELVIN = 273.15d0 
!> critical temperature of water in K
real(real64), parameter ::  Tc1_water = 647.096d0 
!> critical pressure of the water in K
real(real64), parameter ::  pc1_water = 22.064d0 
!> critical temperature of heavy water MPa 
real(real64), parameter ::  Tc1_heavywater = 643.847d0 
!> critical pressure of heavywater MPa 
real(real64), parameter ::  pc1_heavywater = 21.671d0 

!> Number of gases in water
integer(int32), parameter :: ngas_water = 14;
!> Gases available for water
character(len=5), dimension(ngas_water) :: available_gases_water = &
[character(len=5):: "He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"]
!> Molar massed of gases available for water
real(real64), parameter, dimension(ngas_water) :: M_gases_water = &
[M_He, M_Ne, M_Ar, M_Kr, M_Xe, M_H2, M_N2, M_O2, M_CO, M_CO2, M_H2S, M_CH4, M_C2H6, M_SF6]
!> Number of gases in heavy water
integer(int32), parameter :: ngas_heavywater = 7;
!> Gases available for heavy water
character(len=5), parameter, dimension(ngas_heavywater) :: available_gases_heavywater = &
[character(len=5)::"He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"]
!> Molar massed of gases available for heavy water
real(real64), parameter, dimension(ngas_heavywater) :: M_gases_heavywater = &
[M_He, M_Ne, M_Ar, M_Kr, M_Xe, M_D2, M_CH4]

!! ABC table for coefficients
!> Number of cols in the coefficient table
integer(int32), parameter :: abc_ncols = 5
!> Index of col A
integer(int32) :: A = 1
!> Index of col B
integer(int32) :: B = 2
!> Index of col C
integer(int32) :: C = 3
!> Index of col Tmin
integer(int32) :: Tmin = 4
!> Index of col Tmax
integer(int32) :: Tmax = 5

!! ai, bi coefficients
!> Number of indexes for water
integer(int32), parameter :: ni_water = 6
!>ai coefficients for water
real(real64), dimension(ni_water), parameter :: ai_water = [-7.85951783d0, &
                                                      1.84408259d0, &
                                                      -11.78664970d0, &
                                                      22.68074110d0, &
                                                      -15.96187190d0, &
                                                      1.80122502d0] 
!> bi coefficients for water */
real(real64), dimension(ni_water), parameter :: bi_water = [1.000d0, 1.500d0, 3.000d0, 3.500d0, 4.000d0, 7.500d0] 

!> Number of indexes for heavywater
integer(int32), parameter :: ni_heavywater = 5
!>ai coefficients for heavywater
real(real64), dimension(ni_heavywater), parameter :: ai_heavy_water = [-7.8966570d0, &
                                                                       24.7330800d0, &
                                                                       -27.8112800d0, &
                                                                       9.3559130d0, &
                                                                       -9.2200830d0]
!> bi coefficients for heavywater */
real(real64), dimension(ni_heavywater), parameter :: bi_heavy_water = [1.00d0, 1.89d0, 2.00d0, 3.00d0, 3.60d0]

!> ABC constants water.
real(real64), dimension(ngas_water, abc_ncols), parameter :: abc_water = transpose(&
                                                                    reshape([-3.52839d0, 7.12983d0, 4.47770d0, 273.21d0, 553.18d0,&
                                                                    -3.18301d0, 5.31448d0, 5.43774d0, 273.20d0, 543.36d0,&
                                                                    -8.40954d0, 4.29587d0, 10.52779d0, 273.19d0, 568.36d0,&
                                                                    -8.97358d0, 3.61508d0, 11.29963d0, 273.19d0, 525.56d0,&
                                                                    -14.21635d0, 4.00041d0, 15.60999d0, 273.22d0, 574.85d0,&
                                                                    -4.73284d0, 6.08954d0, 6.06066d0, 273.15d0, 636.09d0,&
                                                                    -9.67578d0, 4.72162d0, 11.70585d0, 278.12d0, 636.46d0,&
                                                                    -9.44833d0, 4.43822d0, 11.42005d0, 274.15d0, 616.52d0,&
                                                                    -10.52862d0, 5.13259d0, 12.01421d0, 278.15d0, 588.67d0,&
                                                                    -8.55445d0, 4.01195d0, 9.52345d0, 274.19d0, 642.66d0,&
                                                                    -4.51499d0, 5.23538d0, 4.42126d0, 273.15d0, 533.09d0,&
                                                                    -10.44708d0, 4.66491d0, 12.12986d0, 275.46d0, 633.11d0,&
                                                                    -19.67563d0, 4.51222d0, 20.62567d0, 275.44d0, 473.46d0,&
                                                                    -16.56118d0, 2.15289d0, 20.35440d0, 283.14d0, 505.55d0], &
                                                                    [abc_ncols, ngas_water])) 

contains

!> @brief Compute the henry constant of a given gas.
!! @param ix Gas index for which the computation has to be performed.
!! @param T_K Temperature in K.
!! @param Tc1 Critical temperature.
!! @param pc1 Critical pressure.
!! @param ni Number of indexes for ai and bi coefficients.
!! @param ai ai coefficients.
!! @param bi bi coefficients.
!! @param abc abc table.
!! @return kH Henry constant in mole fraction per GPa.
pure function iapws_G7_04_henry_constant(ix, T_K, Tc1, pc1, ni, ai, bi, abc) result(kh)
    integer(int32), intent(in) :: ix
    real(real64), intent(in) :: T_K
    real(real64), intent(in) :: Tc1
    real(real64), intent(in) :: pc1
    integer(int32), intent(in) :: ni
    real(real64), intent(in), dimension(:) :: ai
    real(real64), intent(in), dimension(:) :: bi
    real(real64), intent(in), dimension(:,:) :: abc
    real(real64) :: kh
    kh = 0.0d0
end function

end module