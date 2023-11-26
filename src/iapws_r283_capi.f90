module iapws__r283_capi
    !! C API for the module R283
    use iso_c_binding
    use iapws__r283
    implicit none
    
    real(c_double), protected, bind(C, name="iapws_r283_capi_Tc_H2O") &
    :: iapws_r283_capi_Tc_H2O = iapws_r283_Tc_H2O !! Critical temperature for H2O in K
    real(c_double), protected, bind(C, name="iapws_r283_capi_Tc_D2O") &
    :: iapws_r283_capi_Tc_D2O = iapws_r283_Tc_D2O !! Critical temperature for D2O in K
    
    real(c_double), protected, bind(C, name="iapws_r283_capi_pc_H2O") &
    :: iapws_r283_capi_pc_H2O = iapws_r283_pc_H2O !! Critical pressure for H2O in MPa
    real(c_double), protected, bind(C, name="iapws_r283_capi_pc_D2O") &
    :: iapws_r283_capi_pc_D2O = iapws_r283_pc_D2O !! Critical pressure for D2O in MPa
    
    real(c_double), protected, bind(C, name="iapws_r283_capi_rhoc_H2O") &
    :: iapws_r283_capi_rhoc_H2O = iapws_r283_rhoc_H2O !! Critical density for H2O in kg.m-3
    real(c_double), protected, bind(C, name="iapws_r283_capi_rhoc_D2O") &
    :: iapws_r283_capi_rhoc_D2O = iapws_r283_rhoc_D2O !! Critical density for D2O in kg.m-3
    
    
end module