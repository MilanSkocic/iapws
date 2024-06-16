#ifndef IAPWS_H
#define IAPWS_H

#if _MSC_VER
#define ADD_IMPORT __declspec(dllimport)
#else
#define ADD_IMPORT
#endif

extern char* iapws_get_version(void);

ADD_IMPORT extern const double iapws_r283_Tc_H2O; 
ADD_IMPORT extern const double iapws_r283_Tc_D2O;

ADD_IMPORT extern const double iapws_r283_pc_H2O;
ADD_IMPORT extern const double iapws_r283_pc_D2O;

ADD_IMPORT extern const double iapws_r283_rhoc_H2O;
ADD_IMPORT extern const double iapws_r283_rhoc_D2O;

extern void iapws_g704_kh(double *T, char *gas, int heavywater, double *k, int size_gas, size_t size_T);
extern void iapws_g704_kd(double *T, char *gas, int heavywater, double *k, int size_gas, size_t size_T);
extern int iapws_g704_ngases(int heavywater);
extern char **iapws_g704_gases(int heavywater);
extern char *iapws_g704_gases2(int heavywater);

#endif
