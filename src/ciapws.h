/**
 *@file ciapws.h
 * @author M. Skocic
 * @brief Header for iapws.
 */

#ifndef CIAPWS
#define CIAPWS

#include "utilities.h"

#define T_KELVIN 273.15 /**< Absolute temperature in KELVIN */
#define Vm 022413.96954 /**< Molar volume of ideal gas (273.15 K, 101.325 kPa) in cm3/mol  */
#define Tc1_water 647.096 /**< critical temperature of water */
#define pc1_water 22.064 /**< critical pressure of the water */
#define Tc1_heavywater 643.847 /**< critical temperature of heavy water */
#define pc1_heavywater 21.671 /**< critical pressure of heavywater */
#define Ms_water (1.0078250321*2+15.9949146221) /**< Molar mass water */
#define Ms_heavywater (2.01410178*2+15.9949146221) /**< Molar mass heavywater */
#define abc_ncols 5 /**<Number of columns in ABC table */
#define Ms_O2 (2*15.9949146221) /**<Molar mass of O2 */


void solubility(char *gas, double T_C, int heavywater, char *solubility_unit, double pressure, int verbose);
double henry_constant(int ix, double T_K, double Tc1, double pc1, int ni, 
                      const double *ai,
                      const double *bi, 
                      const double *abc);
double x2_to_cm3(double x2, double Ms);
double x2_to_ppm(double x2, double Ms, double Mgas);
void print_coefficients(char *gas, int heavywater);

int test_water();
int test_heavywater();

#endif