module iapws__r283
    !! Module for IAPWS R283
    use iso_fortran_env
    implicit none
    
    real(real64), parameter :: iapws_r283_Tc_H2O = 647.096d0 !! Critical temperature for H2O in K
    real(real64), parameter :: iapws_r283_Tc_D2O = 643.847d0 !! Critical temperature for D2O in K
    
    real(real64), parameter :: iapws_r283_pc_H2O = 22.064d0 !! Critical pressure for H2O in MPa
    real(real64), parameter :: iapws_r283_pc_D2O = 21.671d0 !! Critical pressure for H2O in MPa
    
    real(real64), parameter :: iapws_r283_rhoc_H2O = 322.0d0 !! Critical density for H2O in kg.m-3
    real(real64), parameter :: iapws_r283_rhoc_D2O = 356.0d0 !! Critical density for H2O in kg.m-3
    
    
end module