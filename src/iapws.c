/**
 * @file ciapws.c
 * @author M. Skocic
 * @brief Compute the solubility constants for 14 gases in water and 7 gases in heavy water.
 * 
 * The computation is based on the parameters provided by the IAPWS 2004: @f$ k_H = \lim_{x_2 \rightarrow 0} f_2/x_2 @f$.
 * where @f$f_2@f$ and @f$x_2@f$ are, respectively, the liquid-phase fugacity and mole fraction of the solute.
 * The Henry's constant @f$k_H@f$ is given as a function of temperature by:
 * \f{eqnarray*}{
 * \ln \left( \frac{k_H}{p_1^*} \right) = A/T_R + \frac{B \cdot \tau^{0.355}}{T_R} + C \cdot T_R^{-0.41} \cdot \exp \tau \\
 * \tau = 1-T_R \\
 * T_R = T/T_{c1}
 * \f}
 * @f$T_{c1}@f$ is the critical temperature of the solvent as recommended by IAPWS1997
 * (647.096 for H2O and 643.847 K for D2O) and @f$p_1^*@f$ is the vapor pressure of the
 * solvent at the temperature of interest.
 * @f$p_1^*@f$ is calculated from the correlation of Wagner and Pruss for H2O and from
 * the correlation of Harvey and Lemmon  for D2O.
 * Both equations have the form @f$ \ln \left( p_1^{*}/p_{c1} \right) = T_R^{-1} \sum_{i=1}^{n}a_i \tau^{b_i} @f$
 * where the number of terms n is 6 for  H2O and 5 for D2O , @f$p_{c1}@f$ is the critical
 * pressure of the solvent recommended by IAPWS IAPWS1997 (22.064 MPa for H2O and 21.671 MPa for D2O)
 * The Henry's constant :@f$k_H@f$ has a dimension of pressure expressed here in bars:
 * \f{eqnarray*}{
 * x_2 [\text{mole fraction per bar}] = \frac{1}{k_H}\\
 * S [ppm.bar^{-1}] = \frac{x_2 \cdot M_{gas}}{M_s} \cdot 10^6 \\
 * S [cm^3.kg^{-1}.bar^{-1}] = \frac{x_2 \cdot V_m}{M_s}
 * \f}
 *
 * @see [IAPWS2004] Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases in H2O and D2O at High Temperatures », IAPWS, Kyoto, Japan, G7-04, 2004
 * @see [IAPWS1997] Revised Release on the IAPWS Industrial Formulation 1997 for the thermodynamic Properties of Water and Steam, IAPWS, Lucerne Switzerland R7-97, 2012.
 * @see [WagnerPruss] W. Wagner et A. Pruss, « International Equations for the Saturation Properties of Ordinary Water Substance. Revised According to the International Temperature Scale of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987) », Journal of Physical and Chemical Reference Data, vol. 22, n°3, p. 783‑787, mai 1993. <https://doi.org/10.1063/1.555926>
 * @see [HarveyLemmon] A. H. Harvey et E. W. Lemmon, « Correlation for the Vapor Pressure of Heavy Water From the Triple Point to the Critical Point », Journal of Physical and Chemical Reference Data, vol. 31, n°1, p. 173‑181, mars 2002 <https://doi.org/10.1063/1.1430231>
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
 *  Author: Milan Skocic <milan.skocic@icloud.com>
 */

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "utilities.h"
#include "iapws.h"

#define abc_ncols 5 /**<Number of columns in ABC table */

static const char *available_gases_water[] = {"He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"}; /**< Gases for water */
static const double M_gases_water[14] = {M_He, M_Ne, M_Ar, M_Kr, M_Xe, M_H2, M_N2, M_O2, M_CO, M_CO2, M_H2S, M_CH4, M_C2H6, M_SF6}; /**< Gases for heavywater */

static const char *available_gases_heavywater[] = {"He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"};
static const double M_gases_heavywater[7] = {M_He, M_Ne, M_Ar, M_Kr, M_Xe, M_D2, M_CH4};


enum COLS{A, B, C, Tmin, Tmax}; /**< Column indexes in ABC table */

static const int ni_water = 6; /**< Number of indexes for water */
static const double ai_water[6] = {-7.85951783, 1.84408259, -11.78664970, 22.68074110, -15.96187190, 1.80122502}; /**< ai coefficients for water */
static const double bi_water[6] = {1.000, 1.500, 3.000, 3.500, 4.000, 7.500}; /**< bi coefficients for water */

static const int ni_heavywater = 5; /**< Number of indexes for heavywater */
static const double ai_heavy_water[5] = {-7.8966570, 24.7330800, -27.8112800, 9.3559130, -9.2200830}; /**< ai coefficients for heavywater */
static const double bi_heavy_water[5] = {1.00, 1.89, 2.00, 3.00, 3.60}; /**< bi coefficients for heavywater */

static const int ngas_water = 14; /**< Number of gases for water */
static const double abc_water[14][5] = {{-3.52839, 7.12983, 4.47770, 273.21, 553.18},
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

static const int ngas_heavywater = 7; /**< Number of gases for heavywater */
static const double abc_heavywater[7][5] = {{-0.72643, 7.02134, 2.04433, 288.15, 553.18},
                             {-0.91999, 5.65327, 3.17247, 288.18, 549.96},
                             {-7.17725, 4.48177, 9.31509, 288.30, 583.76},
                             {-8.47059, 3.91580, 10.69433, 288.19, 523.06},
                             {-14.46485, 4.42330, 15.60919, 295.39, 574.85},
                             {-5.33843, 6.15723, 6.53046, 288.17, 581.00},
                             {-10.01915, 4.73368, 11.75711, 288.16, 517.46}}; /**< ABC constants heavywater. */


static double Tc1 = Tc1_water; /**< Critical temperature  */
static double pc1 = pc1_water; /**< Critical pressure */
static double Ms = M_water;
static const double *abc = abc_water[0];
static const double *ai = ai_water;
static const double *bi = bi_water;
static const double *M_gases = M_gases_water;
static int ni = ni_water;
static int ngas = ngas_water;
static char solvent[] = "H2O";
static const char **list_gas = available_gases_water;


/** @brief Compute the solubility constants for 14 gases in water and 7 gases in heavy water.
 * Print the result on stdout.
 * @param *gas Gas for which the computation has to be performed.
 * @param T_C Temperature in °C.
 * @param heavywater Flag for selecting heavywater instead of water.
 * @param solubility_unit Unit for the computation.
 * @param pressure Pressure in bar.
 * @param verbose Flag for printing additional information.
 */
void solubility(char *gas, double T_C, int heavywater, char *solubility_unit, double pressure, int verbose)
{
    double T_K;
    double kH;
    double x2;
    double cm3_per_kg_per_bar;
    double ppm;
    int i;
    int ix;
    T_K = T_C+T_KELVIN;

    if (T_C == 0.0)
    {
        printf("Warning: Temperature was set to %f C. Check if the correct temperature was entered.\n", T_C);
    }

    if (heavywater)
    {
        Tc1 = Tc1_heavywater;
        pc1 = pc1_heavywater;
        Ms = M_heavywater;
        abc = abc_heavywater[0];
        ai = ai_heavy_water;
        bi = bi_heavy_water;
        ni = ni_heavywater;
        ngas = ngas_heavywater;
        list_gas = available_gases_heavywater;
        strcpy(solvent, "D2O");
        M_gases = M_gases_heavywater;
    }
    ix = find(gas, list_gas, ngas);
    if (ix < 0)
    {
        printf("Error. %s was not found in the list of available gases in %s.\n", gas, solvent);
    }
    else
    {
        kH = henry_constant(ix, T_K, Tc1, pc1, ni, ai, bi, abc);
        x2 = 1.0/kH; // mole fraction per GPa
        cm3_per_kg_per_bar = x2_to_cm3(x2, Ms);
        ppm = x2_to_ppm(x2, Ms, M_gases[ix]);

        if (verbose){
            printf("Gas = %s at T = %.1f C in %s\n", gas, T_C, solvent);
            printf("ln(kH in GPa) = %.4f\n", log(kH));
            printf("kH = %.4f GPa\n", kH);

        }
        
        if(strcmp(solubility_unit, "gpa")==0){
            printf("x2 = 1/kH = %.4f GPa-1\n", x2);
        }
        
        if (strcmp(solubility_unit, "ppm")==0){
            if (pressure){
                printf("S = %.2f ppm\n", ppm*pressure);
            }else{
                printf("S = %.2f ppm.bar-1\n", ppm);
            }
        }
        if (strcmp(solubility_unit, "ppb")==0){
            if (pressure){
                printf("S = %.2f ppb\n", 1000.0*ppm*pressure);
            }else{
                printf("S = %.2f ppb.bar-1\n", 1000.0*ppm);
            }
        }

        if (strcmp(solubility_unit, "cm3")==0){
            if(pressure){
                printf("S = %.2f cm3.kg-1\n", cm3_per_kg_per_bar*pressure);
            }
            else{       
                printf("S = %.2f cm3.kg-1.bar-1\n", cm3_per_kg_per_bar);
            }
        }

        if(strcmp(solubility_unit, "all")==0){
            printf("x2 = 1/kH = %.4f GPa-1\n", x2);
            if(pressure){
                printf("S = %.2f ppm\n", ppm*pressure);
                printf("S = %.2f cm3.kg-1\n", cm3_per_kg_per_bar*pressure);
            }
            else{
                printf("S = %.2f ppm.bar-1\n", ppm);
                printf("S = %.2f cm3.kg-1.bar-1\n", cm3_per_kg_per_bar);
            }   

        }

    }
}


/** @brief Compute the henry constant of a given gas.
 * @param ix Gas index for which the computation has to be performed.
 * @param T_K Temperature in K.
 * @param Tc1 Critical temperature.
 * @param pc1 Critical pressure.
 * @param ni Number of indexes for ai and bi coefficients
 * @param *ai ai coefficients
 * @param *bi bi coefficients
 * @param *abc abc table
 */
double henry_constant(int ix, double T_K, double Tc1, double pc1, int ni, 
                      const double *ai, 
                      const double *bi, 
                      const double *abc)
{
    double Tr;
    double tau;
    double ln_kH_pstar;
    double res;
    double ln_pstar_pcl;
    double pstar;
    double kH;
    int i;

    Tr = T_K/Tc1;
    tau  = 1-Tr;
    ln_kH_pstar = *(abc+ix*abc_ncols+A)/Tr + *(abc+ix*abc_ncols+B)*pow(tau,0.355)/Tr + *(abc+ix*abc_ncols+C)*exp(tau)*pow(Tr,-0.41);

    res = 0.0;
    for (i=0; i<ni;i++)
    {
        res = res + ai[i]*pow(tau, bi[i]);
    }
    ln_pstar_pcl = 1/Tr * res;
    pstar = exp(ln_pstar_pcl)*pc1; //MPa

    kH = exp(ln_kH_pstar)*pstar/1000.0;

    return kH;

}

/**
 * @brief Convert mole fraction into cm3 per kg per bar.
 * 
 * @param x2 Mole fraction per GPa.
 * @param Ms Molar mass of the solvent.
 * @return Volume of dissolevd gas per kg per bar.
 */
double x2_to_cm3(double x2, double Ms){

    double cm3_per_kg_bar;
    cm3_per_kg_bar = (x2 / 1e4) * Vm / (Ms*1e-3);
    return cm3_per_kg_bar;
}

/**
 * @brief Convert mole fraction to ppm.
 * 
 * @param x2 Mole fraction per GPa.
 * @param Ms Molar mass of the solvent.
 * @param Mgas Molar mass of the gas.
 * @return ppm of dissolved gas.
 */
double x2_to_ppm(double x2, double Ms, double Mgas){

    double ppm;
    ppm = (x2 / 1e4) * Mgas / Ms * 1e6;
    return ppm;
}

/**
 * @brief Print the IAPWS coefficients for the selected gas. 
 * 
 * @param gas Gas for which the coefficient have to be printed.
 * @param heavywater Flag for selecting heavywater instead of water.
 */
void print_coefficients(char *gas, int heavywater){
    
    int i;
    int ix;
    
    if (heavywater)
    {
        Tc1 = Tc1_heavywater;
        pc1 = pc1_heavywater;
        Ms = M_heavywater;
        abc = abc_heavywater[0];
        ai = ai_heavy_water;
        bi = bi_heavy_water;
        ni = ni_heavywater;
        ngas = ngas_heavywater;
        list_gas = available_gases_heavywater;
        strcpy(solvent, "D2O");
        M_gases = M_gases_heavywater;
    }

    ix = find(gas, list_gas, ngas);
    if (ix < 0)
    {
        printf("Error. %s was not found in the list of available gases in %s.\n", gas, solvent);
    }
    else
    {

        printf("\n");
        printf("***** ai and bi Coefficients for %s *****\n", gas);
        for (i=0;i<ni;i++)
        {
            printf("a[%d] = %f \t b[%d] = %f\n", i, ai[i], i, bi[i]);
        }

        printf("\n");
        printf("**** ABC Coefficients for %s *****\n", gas);
        printf("A=%f \t B=%f \t C=%f\n\n",  *(abc+ix*abc_ncols+A), *(abc+ix*abc_ncols+B), *(abc+ix*abc_ncols+C));
    }

}

/**
 * @brief Test the computation of Henry Constant for water.
 */
int test_water()
{
    int cols = 4;
    int i, j;
    double T[4] = {300, 400, 500, 600};
    double kH;
    double ln_kH;

    // data copied directly from PDF of the paper
    // Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
    // in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
    double results[14][4] = {{2.6576, 2.1660, 1.1973, -0.1993},
                        {2.5134, 2.3512, 1.5952, 0.4659},
                        {1.4061, 1.8079, 1.1536, 0.0423},
                        {0.8210, 1.4902, 0.9798, 0.0006},
                        {0.2792, 1.1430, 0.5033, -0.7081},
                        {1.9702, 1.8464, 1.0513, -0.1848},
                        {2.1716, 2.3509, 1.4842, 0.1647},
                        {1.5024, 1.8832, 1.1630, -0.0276},
                        {1.7652, 1.9939, 1.1250, -0.2382},
                        {-1.7508, -0.5450, -0.6524, -1.3489},
                        {-2.8784, -1.7083, -1.6074, -2.1319},
                        {1.4034, 1.7946, 1.0342, -0.2209},
                        {1.1418, 1.8495, 0.8274, -0.8141},
                        {3.1445, 3.6919, 2.6749, 1.2402}};

    printf("\n***** TEST for Water: ln(kH) computed / ln(kH) IPAWS / computed - IAPWS *****\n");
    printf("%4s", "Gas\t");
    for (j=0; j<cols; j++)
    {
        printf("%25dK\t", (int) T[j]);
    }
    printf("\n");
    for (i=0; i<ngas_water; i++)
    {
        printf("%4s\t", available_gases_water[i]);
        for(j=0; j<cols; j++)
        {
            kH = henry_constant(i, T[j], Tc1_water, pc1_water, ni_water, ai_water, bi_water, abc_water[0]);
            ln_kH = roundn(log(kH), 4);
            printf("%+8.4f/%+8.4f/%+8.4f\t", ln_kH, results[i][j], ln_kH - results[i][j]);
        }
        printf("\n");
    }
    return 0;
}

/**
 * @brief Test the computation of Henry Constant for heavywater.
 */
int test_heavywater()
{
    int cols = 4;
    int i, j;
    double T[4] = {300, 400, 500, 600};
    double kH;
    double ln_kH;

    // data copied directly from PDF of the paper
    // Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
    // in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
    double results[14][4] = {{2.5756, 2.1215, 1.2748, -0.0034},
                                {2.4421, 2.2525, 1.5554, 0.4664},
                                {1.3316, 1.7490, 1.1312, 0.0360},
                                {0.8015, 1.4702, 0.9505, -0.0661},
                                {0.2750, 1.1251, 0.4322, -0.8730},
                                {1.6594, 1.6762, 0.9042, -0.3665},
                                {1.3624, 1.7968, 1.0491, -0.2186}};

    printf("\n***** TEST for HeavyWater: ln(kH) computed / ln(kH) IPAWS / computed - IAPWS *****\n");

    printf("%4s", "Gas\t");
    for (j=0; j<cols; j++)
    {
        printf("%25dK\t", (int) T[j]);
    }
    printf("\n");
    for (i=0; i<ngas_heavywater; i++)
    {
        printf("%4s\t", available_gases_water[i]);
        for(j=0; j<cols; j++)
        {
            kH = henry_constant(i, T[j], Tc1_heavywater, pc1_heavywater, ni_heavywater, ai_heavy_water, bi_heavy_water, abc_heavywater[0]);
            ln_kH = roundn(log(kH), 4);
            printf("%+8.4f/%+8.4f/%+8.4f\t", ln_kH, results[i][j], ln_kH - results[i][j]);
        }
        printf("\n");
    }
    return 0;
}





