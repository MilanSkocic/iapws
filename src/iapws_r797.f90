module iapws__r797
    !! Module for IAPWS R7-97
    use iso_fortran_env
    use ieee_arithmetic
    implicit none
    private

    
!! Parameters from IAPWS R7-97
!! critical temperature of water in K
real(real64), parameter ::  Tc = 647.096d0 
!! critical pressure of the water in MPa
real(real64), parameter ::  pc = 22.064d0 
!! critical density of the water in kg.m-3.
real(real64), parameter :: rhoc = 322.0d0
!! Specific gas constant 0.461 526 kJ.kg-1.K-1
real(real64), parameter :: R = 0.461526d0

!! IJn_r1f
real(real64) :: IJn_r1f(1, 3) = transpose(reshape(&
[0.0d0, -2.0d0, 0.146d0], &
[3, 1]))

contains



end module