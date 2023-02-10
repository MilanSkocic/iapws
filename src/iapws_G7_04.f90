!> @file
!! The molar masses were taken from the NIST website: https://www.nist.gov/pml/periodic-table-elements.
!! 
!! Copyright (C) 2020-2022  Milan Skocic.
!!
!! This program is free software: you can redistribute it and/or modify
!! it under the terms of the GNU General Public License as published by
!! the Free Software Foundation, either version 3 of the License, or
!! (at your option) any later version.
!!
!! This program is distributed in the hope that it will be useful,
!! but WITHOUT ANY WARRANTY; without even the implied warranty of
!! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
!! GNU General Public License for more details.
!!
!! You should have received a copy of the GNU General Public License
!! along with this program.  If not, see <https://www.gnu.org/licenses/>. 
!!
!!
!! Author: Milan Skocic <milan.skocic@icloud.com>

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