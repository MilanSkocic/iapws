!> @file

!> @brief Constants for computations
!! @details The molar masses were taken from the NIST website: https://www.nist.gov/pml/periodic-table-elements.
module iapws_constants
    use iso_fortran_env
    implicit none

!> Absolute temperature in KELVIN 
real(real64), parameter ::  T_KELVIN = 273.15d0 

!! Molar masses from the NIST website 
real(real64), parameter :: M_H = 1.008d0 
real(real64), parameter :: M_D = 2.014d0
real(real64), parameter :: M_N = 14.007d0
real(real64), parameter :: M_O = 15.999d0
real(real64), parameter :: M_C = 12.011d0
real(real64), parameter :: M_S = 32.06d0 
real(real64), parameter :: M_F = 18.998d0 

real(real64), parameter :: M_He = 4.0026d0
real(real64), parameter :: M_Ne = 20.180d0 
real(real64), parameter :: M_Ar = 39.948d0 
real(real64), parameter :: M_Kr = 83.798d0 
real(real64), parameter :: M_Xe = 131.29d0 
real(real64), parameter :: M_H2 = (2*M_H) 
real(real64), parameter :: M_N2 = (2*M_N) 
real(real64), parameter :: M_O2 = (2*M_O) 
real(real64), parameter :: M_CO = (M_C + M_O) 
real(real64), parameter :: M_CO2 = (M_C + 2*M_O) 
real(real64), parameter :: M_H2S = (M_H*2 + M_S) 
real(real64), parameter :: M_CH4 = (M_H*4 + M_C) 
real(real64), parameter :: M_C2H6 = (M_H*6 + M_C*2)
real(real64), parameter :: M_SF6 = (M_F*6 + M_S) 
real(real64), parameter :: M_D2 = (2*M_D) 

real(real64), parameter :: M_water = (M_H*2+M_O) 
real(real64), parameter :: M_heavywater = (M_D*2+M_O)
!> Molar volume of ideal gas (273.15 K, 100 kPa) in cm3/mol 
real(real64), parameter ::  Vm_1b = 22710.95464d0 

end module