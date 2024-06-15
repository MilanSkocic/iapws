#ifndef CIAPWS_G704_H
#define CIAPWS_G704_H

extern void ciapws_g704_capi_kh(double *T, char *gas, int heavywater, double *k, int size_gas, size_t size_T);
extern void ciapws_g704_capi_kd(double *T, char *gas, int heavywater, double *k, int size_gas, size_t size_T);
extern int ciapws_g704_capi_ngases(int heavywater);
extern char **ciapws_g704_capi_gases(int heavywater);
extern char *ciapws_g704_capi_gases2(int heavywater);

#endif
