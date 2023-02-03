module iapws_G7_04
    use iso_fortran_env
    implicit none

!! Parameters from IAPWS G7-04 
real(real64), parameter ::  T_KELVIN = 273.15d0 !> Absolute temperature in KELVIN 
real(real64), parameter ::  Tc1_water = 647.096d0 !> critical temperature of water in K
real(real64), parameter ::  pc1_water = 22.064d0 !> critical pressure of the water in K
real(real64), parameter ::  Tc1_heavywater = 643.847d0 !> critical temperature of heavy water MPa 
real(real64), parameter ::  pc1_heavywater = 21.671d0 !> critical pressure of heavywater MPa 

end module