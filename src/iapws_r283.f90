module iapws__r283
    !! Module for IAPWS R283
    use iso_fortran_env
    use iso_c_binding
    implicit none
    
    real(real64), parameter :: Tc_H2O = 647.096d0 !! Critical temperature for H2O in K
    real(real64), parameter :: Tc_D2O = 643.847d0 !! Critical temperature for D2O in K
    
    real(real64), parameter :: pc_H2O = 22.064d0 !! Critical pressure for H2O in MPa
    real(real64), parameter :: pc_D2O = 21.671d0 !! Critical pressure for H2O in MPa
    
    real(real64), parameter :: rhoc_H2O = 322.0d0 !! Critical density for H2O in kg.m-3
    real(real64), parameter :: rhoc_D2O = 356.0d0 !! Critical density for H2O in kg.m-3
    
    real(c_double), protected, bind(C, name="iapws_Tc_H2O") &
    :: capi_Tc_H2O = Tc_H2O !! Critical temperature for H2O in K
    real(c_double), protected, bind(C, name="iapws_Tc_D2O") &
    :: capi_Tc_D2O = Tc_D2O !! Critical temperature for D2O in K
    
    real(c_double), protected, bind(C, name="iapws_pc_H2O") &
    :: capi_pc_H2O = pc_H2O !! Critical pressure for H2O in MPa
    real(c_double), protected, bind(C, name="iapws_pc_D2O") &
    :: capi_pc_D2O = pc_D2O !! Critical pressure for D2O in MPa
    
    real(c_double), protected, bind(C, name="iapws_rhoc_H2O") &
    :: capi_rhoc_H2O = rhoc_H2O !! Critical density for H2O in kg.m-3
    real(c_double), protected, bind(C, name="iapws_rhoc_D2O") &
    :: capi_rhoc_D2O = rhoc_D2O !! Critical density for D2O in kg.m-3
    
    
end module
