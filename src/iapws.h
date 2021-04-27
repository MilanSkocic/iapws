/**
 *@file iapws.h
 * @author M. Skocic
 * @brief Header for iapws.
 */

#ifndef IAPWS
#define IAPWS

#include "utilities.h"

void solubility(char *gas, double T_C, int heavywater, int print);
double henry_constant(int ix, double T_K, double Tc1, double pc1, int ni, double *ai, double *bi, double *abc);
void test_water();
void test_heavywater();

#endif