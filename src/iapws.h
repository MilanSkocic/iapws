/**
 *@file iapws.h
 * @author M. Skocic
 * @brief Header for iapws.
 */

#ifndef IAPWS
#define IAPWS

double convert_to_kelvin(double T);
int find(char *item, char **list, int size);
void solubility(char *gas, double T_C, int heavywater, int print);
double henry_constant(int ix, double T_K, double Tc1, double pc1, int ni, double *ai, double *bi, double *abc);
void test_water();
void test_heavywater();
double roundn(double x, int n);

#endif