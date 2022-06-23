/**
 *@file iapws.h
 * @author M. Skocic
 * @brief Header for iapws.
 */

#ifndef IAPWS
#define IAPWS

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
#define Ms_O2 (2*15.9949146221)

char *available_gases_water[] = {"He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"}; /**< Gases for water */
double M_gases_water[14] = {4.002602, 20.1797, 39.948, 83.798, 131.293, 2.01588, 28.0134, Ms_O2, 28.0101, 44.0095, 34.08088, 16.04246, 30.06904, 146.0554192}; /**< Gases for heavywater */

char *available_gases_heavywater[] = {"He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"};
double M_gases_heavywater[7] = {4.002602, 20.1797, 39.948, 83.798, 131.293, 4.02820356, 16.04246};


enum {A, B, C, Tmin, Tmax}; /**< Column indexes in ABC table */

int ni_water = 6; /**< Number of indexes for water */
double ai_water[6] = {-7.85951783, 1.84408259, -11.78664970, 22.68074110, -15.96187190, 1.80122502}; /**< ai coefficients for water */
double bi_water[6] = {1.000, 1.500, 3.000, 3.500, 4.000, 7.500}; /**< bi coefficients for water */

int ni_heavywater = 5; /**< Number of indexes for heavywater */
double ai_heavy_water[5] = {-7.8966570, 24.7330800, -27.8112800, 9.3559130, -9.2200830}; /**< ai coefficients for heavywater */
double bi_heavy_water[5] = {1.00, 1.89, 2.00, 3.00, 3.60}; /**< bi coefficients for heavywater */

int ngas_water = 14; /**< Number of gases for water */
double abc_water[14][5] = {{-3.52839, 7.12983, 4.47770, 273.21, 553.18},
                             {-3.18301, 5.31448, 5.43774, 273.20, 543.36},
                             {-8.40954, 4.29587, 10.52779, 273.19, 568.36},
                             {-8.97358, 3.61508, 11.29963, 273.19, 525.56},
                             {-14.21635, 4.00041, 15.60999, 273.22, 574.85},
                             {-4.73284, 6.08954, 6.06066, 273.15, 636.09},
                             {-9.67578, 4.72162, 11.70585, 278.12, 636.46},
                             {-9.44833, 4.43822, 11.42005, 274.15, 616.52},
                             {-10.52862, 5.13259, 12.01421, 278.15, 588.67},
                             {-8.55445, 4.01195, 9.52345, 274.19, 642.66},
                             {-4.51499, 5.23538, 4.42126, 273.15, 533.09},
                             {-10.44708, 4.66491, 12.12986, 275.46, 633.11},
                             {-19.67563, 4.51222, 20.62567, 275.44, 473.46},
                             {-16.56118, 2.15289, 20.35440, 283.14, 505.55}}; /**< ABC constants water. */

int ngas_heavywater = 7; /**< Number of gases for heavywater */
double abc_heavywater[7][5] = {{-0.72643, 7.02134, 2.04433, 288.15, 553.18},
                             {-0.91999, 5.65327, 3.17247, 288.18, 549.96},
                             {-7.17725, 4.48177, 9.31509, 288.30, 583.76},
                             {-8.47059, 3.91580, 10.69433, 288.19, 523.06},
                             {-14.46485, 4.42330, 15.60919, 295.39, 574.85},
                             {-5.33843, 6.15723, 6.53046, 288.17, 581.00},
                             {-10.01915, 4.73368, 11.75711, 288.16, 517.46}}; /**< ABC constants heavywater. */


void solubility(char *gas, double T_C, int heavywater, int print, char *solubility_unit, double pressure, int verbose);
double henry_constant(int ix, double T_K, double Tc1, double pc1, int ni, double *ai, double *bi, double *abc);
double x2_to_cm3(double x2, double Ms);
double x2_to_ppm(double x2, double Ms, double Mgas);

int test_water();
int test_heavywater();

#endif