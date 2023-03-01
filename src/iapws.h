/**
 * @file iapws.h
 */


extern void iapws_capi_kh(double T, char *gas, char *solvent, 
                          double *kh, int *status, int size_gas, int size_solvent);