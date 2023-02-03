module iapws_constants
    use iso_fortran_env
    implicit none

!! Molar masses from the NIST website 
real(real64), parameter :: M_H = 1.008d0 !>Molar mass of H in g.mol-1. 
real(real64), parameter :: M_D = 2.014d0 !>Molar mass of D in g.mol-1. 
real(real64), parameter :: M_N = 14.007d0 !>Molar mass of N in g.mol-1. 
real(real64), parameter :: M_O = 15.999d0 !>Molar of O in g.mol-1 
real(real64), parameter :: M_C = 12.011d0 !>Molar of C in g.mol-1 
real(real64), parameter :: M_S = 32.06d0 !>Molar of S in g.mol-1 
real(real64), parameter :: M_F = 18.998d0 !>Molar of F in g.mol-1 

real(real64), parameter :: M_He = 4.0026d0 !>Molar of He in g.mol-1 
real(real64), parameter :: M_Ne = 20.180d0 !>Molar of Ne in g.mol-1 
real(real64), parameter :: M_Ar = 39.948d0 !>Molar of Ar in g.mol-1 
real(real64), parameter :: M_Kr = 83.798d0 !>Molar of Kr in g.mol-1 
real(real64), parameter :: M_Xe = 131.29d0 !>Molar of Xe in g.mol-1 
real(real64), parameter :: M_H2 = (2*M_H) !>Molar mass of H2 in g.mol-1 
real(real64), parameter :: M_N2 = (2*M_N) !>Molar mass of N2 in g.mol-1. 
real(real64), parameter :: M_O2 = (2*M_O) !><Molar mass of O2 in g.mol-1 
real(real64), parameter :: M_CO = (M_C + M_O) !><Molar mass of CO 
real(real64), parameter :: M_CO2 = (M_C + 2*M_O) !><Molar mass of CO2 g.mol-1
real(real64), parameter :: M_H2S = (M_H*2 + M_S) !><Molar mass of H2S g.mol-1
real(real64), parameter :: M_CH4 = (M_H*4 + M_C) !><Molar mass of CH4 g.mol-1
real(real64), parameter :: M_C2H6 = (M_H*6 + M_C*2) !><Molar mass of C2H6 g.mol-1
real(real64), parameter :: M_SF6 = (M_F*6 + M_S) !><Molar mass of SF6 g.mol-1
real(real64), parameter :: M_D2 = (2*M_D) !>Molar mass of D2 in g.mol-1 

real(real64), parameter :: M_water = (M_H*2+M_O) !>Molar mass water 
real(real64), parameter :: M_heavywater = (M_D*2+M_O) !>Molar mass heavywater 

real(real64), parameter ::  Vm = 022413.96954d0 !> Molar volume of ideal gas (273.15 K, 101.325 kPa) in cm3/mol  

end module