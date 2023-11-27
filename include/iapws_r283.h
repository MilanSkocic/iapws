/**
 * @file iapws_r283.h
 * @brief C header for the module iapws_r283.
 */

#ifndef IAPWS_R283_H
#define IAPWS_R283_H

#if _MSC_VER
#define ADD_IMPORT __declspec(dllimport)
#else
#define ADD_IMPORT
#endif

ADD_IMPORT extern const double iapws_r283_capi_Tc_H2O; 
ADD_IMPORT extern const double iapws_r283_capi_Tc_D2O;

ADD_IMPORT extern const double iapws_r283_capi_pc_H2O;
ADD_IMPORT extern const double iapws_r283_capi_pc_D2O;

ADD_IMPORT extern const double iapws_r283_capi_rhoc_H2O;
ADD_IMPORT extern const double iapws_r283_capi_rhoc_D2O;

#endif
