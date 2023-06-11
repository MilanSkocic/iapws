/**
 * @file iapws_g704.h
 * @brief C header for the module iapws_g704.
 */

#ifndef IAPWS_G704_H
#define IAPWS_G704_H

extern void iapws_g704_capi_kh(double *T, char *gas, int heavywater, double *k, int size_gas, size_t size_T);
extern void iapws_g704_capi_kd(double *T, char *gas, int heavywater, double *k, int size_gas, size_t size_T);
extern int iapws_g704_capi_ngases(int heavywater);
extern char **iapws_g704_capi_gases(int heavywater);
extern char *iapws_g704_capi_gases2(int heavywater);

#endif
