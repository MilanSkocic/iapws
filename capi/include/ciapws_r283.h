#ifndef CIAPWS_R283_H
#define CIAPWS_R283_H

#if _MSC_VER
#define ADD_IMPORT __declspec(dllimport)
#else
#define ADD_IMPORT
#endif

ADD_IMPORT extern const double ciapws_r283_tc_h2o; 
ADD_IMPORT extern const double ciapws_r283_tc_d2o;

ADD_IMPORT extern const double ciapws_r283_pc_h2o;
ADD_IMPORT extern const double ciapws_r283_pc_d2o;

ADD_IMPORT extern const double ciapws_r283_rhoc_h2o;
ADD_IMPORT extern const double ciapws_r283_rhoc_d2o;

#endif
