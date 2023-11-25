module iapws__r283_capi
    !! C API for the module R283
    use iso_c_binding
    use iapws__r283
    implicit none
    
    real(c_double), protected, bind(C, name="iapws_r283_capi_Tc_H2O") &
    :: iapws_r283_capi_Tc_H2O = iapws_r283_Tc_H2O
    real(c_double), protected, bind(C, name="iapws_r283_capi_Tc_D2O") &
    :: iapws_r283_capi_Tc_D2O = iapws_r283_Tc_D2O
    
    real(c_double), protected, bind(C, name="iapws_r283_capi_pc_H2O") &
    :: iapws_r283_capi_pc_H2O = iapws_r283_pc_H2O
    real(c_double), protected, bind(C, name="iapws_r283_capi_pc_D2O") &
    :: iapws_r283_capi_pc_D2O = iapws_r283_pc_D2O
    
    real(c_double), protected, bind(C, name="iapws_r283_capi_rhoc_H2O") &
    :: iapws_r283_capi_rhoc_H2O = iapws_r283_rhoc_H2O
    real(c_double), protected, bind(C, name="iapws_r283_capi_rhoc_D2O") &
    :: iapws_r283_capi_rhoc_D2O = iapws_r283_rhoc_D2O
    
    
end module