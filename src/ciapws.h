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

#define M_H 1.0078250321 /**< Molar mass of H in g.mol-1. */
#define M_D 2.01410178 /**< Molar mass of D in g.mol-1. */
#define M_O (+ 15.99491461957 * 99.757/100.0 \
             + 16.9991317565 * 0.038/100.0 \
             + 17.9991596129 * 0.205/100.0) /**< Molar of O in g.mol-1 */


#define M_H2 (2*M_H) /**< Molar mass of H2 in g.mol-1 */
#define M_D2 (2*M_D) /**< Molar mass of D2 in g.mol-1 */
#define M_O2 (2*M_O) /**<Molar mass of O2 */

#define M_water (M_H*2+M_O) /**< Molar mass water */
#define M_heavywater (M_D*2+M_O) /**< Molar mass heavywater */


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