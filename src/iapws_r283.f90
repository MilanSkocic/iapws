module iapws__r283
!! Module for IAPWS R2-83.
use iapws__common, only: dp, c_double
implicit none(type,external)
private

real(dp), parameter :: Tc_H2O = 647.096_dp !! Critical temperature for H2O in K
real(dp), parameter :: Tc_D2O = 643.847_dp !! Critical temperature for D2O in K
real(dp), parameter :: pc_H2O = 22.064_dp !! Critical pressure for H2O in MPa
real(dp), parameter :: pc_D2O = 21.671_dp !! Critical pressure for H2O in MPa
real(dp), parameter :: rhoc_H2O = 322.0_dp !! Critical density for H2O in kg.m-3
real(dp), parameter :: rhoc_D2O = 356.0_dp !! Critical density for H2O in kg.m-3

real(c_double), protected, bind(C, name="iapws_r283_Tc_H2O") :: capi_Tc_H2O = Tc_H2O !! Critical temperature for H2O in K
real(c_double), protected, bind(C, name="iapws_r283_Tc_D2O") :: capi_Tc_D2O = Tc_D2O !! Critical temperature for D2O in K
real(c_double), protected, bind(C, name="iapws_r283_pc_H2O") :: capi_pc_H2O = pc_H2O !! Critical pressure for H2O in MPa
real(c_double), protected, bind(C, name="iapws_r283_pc_D2O") :: capi_pc_D2O = pc_D2O !! Critical pressure for D2O in MPa
real(c_double), protected, bind(C, name="iapws_r283_rhoc_H2O") :: capi_rhoc_H2O = rhoc_H2O !! Critical density for H2O in kg.m-3
real(c_double), protected, bind(C, name="iapws_r283_rhoc_D2O") :: capi_rhoc_D2O = rhoc_D2O !! Critical density for D2O in kg.m-3

!=======================================================================
! PUBLIC
!=======================================================================
public :: Tc_H2O, Tc_D2O, pc_H2O, pc_D2O, rhoc_H2O, rhoc_D2O
public :: capi_Tc_H2O, capi_Tc_D2O, capi_pc_H2O, capi_pc_D2O, capi_rhoc_H2O, capi_rhoc_D2O
!=======================================================================

end module iapws__r283
