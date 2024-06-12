module ciapws__r783
    !! Module for IAPWS R283
    use iso_c_binding, only: c_double
    use iapws__r283
    implicit none
    private
    
    real(c_double), protected, bind(C) :: ciapws_r283_Tc_H2O = Tc_H2O !! Critical temperature for H2O in K
    real(c_double), protected, bind(C) :: ciapws_r283_Tc_D2O = Tc_D2O !! Critical temperature for D2O in K
    
    real(c_double), protected, bind(C) :: ciapws_r283_pc_H2O = pc_H2O !! Critical pressure for H2O in MPa
    real(c_double), protected, bind(C) :: ciapws_r283_pc_D2O = pc_D2O !! Critical pressure for D2O in MPa
    
    real(c_double), protected, bind(C) :: ciapws_r283_rhoc_H2O = rhoc_H2O !! Critical density for H2O in kg.m-3
    real(c_double), protected, bind(C) :: ciapws_r283_rhoc_D2O = rhoc_D2O !! Critical density for D2O in kg.m-3

    public :: ciapws_r283_Tc_H2O, &
              ciapws_r283_Tc_D2O, &
              ciapws_r283_pc_H2O, &
              ciapws_r283_pc_D2O, &
              ciapws_r283_rhoc_H2O, &
              ciapws_r283_rhoc_D2O

end module
