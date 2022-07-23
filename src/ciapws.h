/**
 *@file ciapws.h
 * @author M. Skocic
 * @brief Header for iapws.
 */

#ifndef CIAPWS
#define CIAPWS

#define T_KELVIN 273.15 /**< Absolute temperature in KELVIN */
#define Vm 022413.96954 /**< Molar volume of ideal gas (273.15 K, 101.325 kPa) in cm3/mol  */
#define Tc1_water 647.096 /**< critical temperature of water in K*/
#define pc1_water 22.064 /**< critical pressure of the water in K*/
#define Tc1_heavywater 643.847 /**< critical temperature of heavy water MPa */
#define pc1_heavywater 21.671 /**< critical pressure of heavywater MPa */

#define Ms_H 1.0078250321 /**< Molar mass of H in g.mol-1. */
#define Ms_O 15.9949146221 /**< Molar of O in g.mol-1 */

#define Ms_H2 (2*Ms_H)
#define Ms_O2 (2*Ms_O) /**<Molar mass of O2 */

#define Ms_water (Ms_H*2+15.9949146221) /**< Molar mass water */
#define Ms_heavywater (2.01410178*2+15.9949146221) /**< Molar mass heavywater */
#define abc_ncols 5 /**<Number of columns in ABC table */




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