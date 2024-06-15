#ifndef CIAPWS_R283_H
#define CIAPWS_R283_H

#if _MSC_VER
#define ADD_IMPORT __declspec(dllimport)
#else
#define ADD_IMPORT
#endif

ADD_IMPORT extern const double ciapws_Tc_H2O; 
ADD_IMPORT extern const double ciapws_Tc_D2O;

ADD_IMPORT extern const double ciapws_pc_H2O;
ADD_IMPORT extern const double ciapws_pc_D2O;

ADD_IMPORT extern const double ciapws_rhoc_H2O;
ADD_IMPORT extern const double ciapws_rhoc_D2O;

#endif
