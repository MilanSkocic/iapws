!> @file

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

end module