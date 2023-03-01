/**
 * @file ciapws.h
 * @author M. Skocic
 * @brief Header for iapws.
 * 
 * The molar masses were taken from the NIST website: https://www.nist.gov/pml/periodic-table-elements.
 * 
 * Copyright (C) 2020-2022  Milan Skocic.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>. 
 *
 *
 * Author: Milan Skocic <milan.skocic@icloud.com>
 * 
 * 
 * 
 */

#ifndef CIAPWS
#define CIAPWS

/* Parameters from IAPWS G7-04 */
#define T_KELVIN 273.15 /**< Absolute temperature in KELVIN */
#define Vm 022413.96954 /**< Molar volume of ideal gas (273.15 K, 101.325 kPa) in cm3/mol  */
#define Tc1_water 647.096 /**< critical temperature of water in K*/
#define pc1_water 22.064 /**< critical pressure of the water in K*/
#define Tc1_heavywater 643.847 /**< critical temperature of heavy water MPa */
#define pc1_heavywater 21.671 /**< critical pressure of heavywater MPa */

/* Molar masses from the NIST website */
#define M_H 1.008 /**< Molar mass of H in g.mol-1. */
#define M_D 2.014 /**< Molar mass of D in g.mol-1. */
#define M_N 14.007 /**< Molar mass of N in g.mol-1. */
#define M_O 15.999 /**< Molar of O in g.mol-1 */
#define M_C 12.011 /**< Molar of C in g.mol-1 */
#define M_S 32.06 /**< Molar of S in g.mol-1 */
#define M_F 18.998 /**< Molar of F in g.mol-1 */

#define M_He 4.0026 /**< Molar of He in g.mol-1 */
#define M_Ne 20.180 /**< Molar of Ne in g.mol-1 */
#define M_Ar 39.948 /**< Molar of Ar in g.mol-1 */
#define M_Kr 83.798 /**< Molar of Kr in g.mol-1 */
#define M_Xe 131.29 /**< Molar of Xe in g.mol-1 */
#define M_H2 (2*M_H) /**< Molar mass of H2 in g.mol-1 */
#define M_N2 (2*M_N) /**< Molar mass of N2 in g.mol-1. */
#define M_O2 (2*M_O) /**<Molar mass of O2 in g.mol-1 */
#define M_CO (M_C + M_O) /**<Molar mass of CO */
#define M_CO2 (M_C + 2*M_O) /**<Molar mass of CO2 g.mol-1*/
#define M_H2S (M_H*2 + M_S) /**<Molar mass of H2S g.mol-1*/
#define M_CH4 (M_H*4 + M_C) /**<Molar mass of CH4 g.mol-1*/
#define M_C2H6 (M_H*6 + M_C*2) /**<Molar mass of C2H6 g.mol-1*/
#define M_SF6 (M_F*6 + M_S) /**<Molar mass of SF6 g.mol-1*/
#define M_D2 (2*M_D) /**< Molar mass of D2 in g.mol-1 */

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