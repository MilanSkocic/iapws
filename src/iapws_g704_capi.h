/**
 * @file iapws_g704.h
 * @brief C header for the module iapws_g704.
 */

#ifndef IAPWS_G704_H
#define IAPWS_G704_H

extern double iapws_capi_kh(double T, char *gas, char *solvent, int size_gas, int size_solvent);
extern double iapws_capi_kd(double T, char *gas, char *solvent, int size_gas, int size_solvent);

#endif
