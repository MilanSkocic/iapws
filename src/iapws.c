/**
 * @file iapws.c
 * @author M. Skocic
 * @brief Compute the solubility constants for 14 gases in water and 7 gases in heavy water.
 * @date 2020/08/04
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
 * wt_2 = \text{molfrac2massfrac}(x_2)\\
 * S [ppm.bar^{-1}] = \text{massfraction2ppm}(wt_2)\\
 * S [cm^3.kg^{-1}.bar^{-1}] = \frac{x_2 \cdot V_m}{M_s}
 * \f}
 *
 * @see [IAPWS2004] Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases in H2O and D2O at High Temperatures », IAPWS, Kyoto, Japan, G7-04, 2004
 * @see [IAPWS1997] Revised Release on the IAPWS Industrial Formulation 1997 for the thermodynamic Properties of Water and Steam, IAPWS, Lucerne Switzerland R7-97, 2012.
 * @see [WagnerPruss] W. Wagner et A. Pruss, « International Equations for the Saturation Properties of Ordinary Water Substance. Revised According to the International Temperature Scale of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987) », Journal of Physical and Chemical Reference Data, vol. 22, n°3, p. 783‑787, mai 1993. <https://doi.org/10.1063/1.555926>
 * @see [HarveyLemmon] A. H. Harvey et E. W. Lemmon, « Correlation for the Vapor Pressure of Heavy Water From the Triple Point to the Critical Point », Journal of Physical and Chemical Reference Data, vol. 31, n°1, p. 173‑181, mars 2002 <https://doi.org/10.1063/1.1430231>

 */
#include <stdio.h>
#include <string.h>
#include <math.h>
#include "iapws.h"

#define T_KELVIN 273.16 /**< Absolute temperature in KELVIN */
#define Vm (0.02241396954*1e6) /**< Molar volume of ideal gas (273.15 K, 101.325 kPa)  */
#define Tc1_water 647.896 /**< critical temperature of water */
#define pc1_water 22.064 /**< critical pressure of the water */
#define Tc1_heavywater 643.847 /**< critical temperature of heavy water */
#define pc1_heavywater 21.671 /**< critical pressure of heavywater */
#define Ms_water (1.0078250321*2+15.9949146221) /**< Molar mass water */
#define Ms_heavywater (2.01410178*2+15.9949146221) /**< Molar mass heavywater */

static char *available_gases_water[] = {"He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"};
static double M_gases[14] = {4.002602, 20.1797, 39.948, 83.798, 131.293, 2.01588, 28.0134, 31.9988, 28.0101, 44.0095, 34.08088, 16.04246, 30.06904, 146.0554192};

static char *available_gases_heavywater[] = {"He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"};
static double M_gases_water[7] = {4.002602, 20.1797, 39.948, 83.798, 131.293, 4.02820356, 16.04246};


enum {A, B, C, Tmin, Tmax};

static int ni_water = 6;
static double ai_water[6] = {-7.85951783, 1.84408259, -11.78664970, 22.68074110, -15.96187190, 1.80122502};
static double bi_water[6] = {1.000, 1.500, 3.000, 3.500, 4.000, 7.500};

static int ni_heavywater = 5;
static double ai_heavy_water[5] = {-7.8966570, 24.7330800, -27.8112800, 9.3559130, -9.2200830};
static double bi_heavy_water[5] = {1.00, 1.89, 2.00, 3.00, 3.60};

static int ngas_water = 14;
static double abc_water[14][5] = {{-3.52839, 7.12983, 4.47770, 273.21, 553.18},
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

static int ngas_heavywater = 7;
static double abc_heavywater[7][5] = {{-0.72643, 7.02134, 2.04433, 288.15, 553.18},
                             {-0.91999, 5.65327, 3.17247, 288.18, 549.96},
                             {-7.17725, 4.48177, 9.31509, 288.30, 583.76},
                             {-8.47059, 3.91580, 10.69433, 288.19, 523.06},
                             {-14.46485, 4.42330, 15.60919, 295.39, 574.85},
                             {-5.33843, 6.15723, 6.53046, 288.17, 581.00},
                             {-10.01915, 4.73368, 11.75711, 288.16, 517.46}}; /**< ABC constants heavywater. */


/** @brief Compute the solubility constants for 14 gases in water and 7 gases in heavy water.
 * Print the result on stdout.
 * @param *gas Gas for which the computation has to be performed.
 * @param T_C Temperature in °C.
 * @param heavywater Flag for selecting heavywater instead of water.
 */
void solubility(char *gas, double T_C, int heavywater, int print)
{
    double Tc1=Tc1_water;
    double pc1=pc1_water;
    double Ms=Ms_water;
    double (*abc)[5] = abc_water;
    double *ai = ai_water;
    double *bi = bi_water;
    int ni = ni_water;
    int ngas = ngas_water;
    char solvent[4] = "H2O";
    char **list_gas = available_gases_water;
    double T_K=298.0;
    double Tr=0.0;
    double tau=0.0;
    double ln_kH_pstar=0.0;
    double res=0.0;
    double ln_pstar_pcl=0.0;
    double pstar=0.0;
    double kH=0.0;
    double x2=0.0;
    double cm3_per_kg_per_bar=0.0;
    double ppm;
    int i=0;
    int ix=0;
    T_K = T_C+T_KELVIN;

    if (T_C == 0.0)
    {
        printf("Warning: Temperature was set to %f C. Check if the correct temperature was entered.\n", T_C);
    }

    if (heavywater)
    {
        Tc1 = Tc1_heavywater;
        pc1 = pc1_heavywater;
        Ms = Ms_heavywater;
        abc = abc_heavywater;
        ai = ai_heavy_water;
        bi = bi_heavy_water;
        ni = ni_heavywater;
        ngas = ngas_heavywater;
        list_gas = available_gases_heavywater;
        strcpy(solvent, "D2O");
    }
    ix = find(gas, list_gas, ngas);
    if (ix < 0)
    {
        printf("Error. %s was not found in the list of available gases in %s.", gas, solvent);
    }
    else
    {
        Tr = T_K/Tc1;
        tau  = 1-Tr;
        ln_kH_pstar = abc[ix][A]/Tr + abc[ix][B]*pow(tau,0.355)/Tr + abc[ix][C]*exp(tau)*pow(Tr,-0.41);

        for (i=0; i<ni;i++)
        {
            res = res + ai[i]*pow(tau, bi[i]);
        }

        ln_pstar_pcl = 1/Tr * res;
        pstar = exp(ln_pstar_pcl)*pc1; //MPa

        kH = exp(ln_kH_pstar)*pstar/1000.0;
        x2 = 1.0/kH; // mole fraction per GPa
        cm3_per_kg_per_bar = (x2 / 1e4) * Vm / (Ms*1e-3);
        ppm = cm3_per_kg_per_bar * M_gases[ix]*1e3 / Vm;


        printf("Gas = %s at T = %.1f C in %s\n", gas, T_C, solvent);
        printf("ln(kH in GPa) = %f\n", log(kH));
        printf("kH = %f GPa\n", kH);
        printf("x2 = 1/kH = %f GPa-1\n", x2);
        printf("S = %f cm3.kg-1.bar-1\n", cm3_per_kg_per_bar);
        printf("S = %f ppm.bar-1\n", ppm);

        if (print)
        {
            printf("\n\n");
            for (i=0;i<ni;i++)
            {
                printf("a[%d] = %f \t b[%d] = %f\n", i, ai[i], i, bi[i]);
            }
        }

    }

}

/**
 * @brief Find the index of an item in a list of strings.
 * @param item Item to be found in list.
 * @param list List of strings.
 * @param size Size of the list.
 * @return index >0 if item was found or -1 if not found.
 */
int find(char *item, char **list, int size)
{
    int i=0;
    int index=-1;
    for (i=0;i<size;i++)
    {

        if (strcmp(list[i], item)==0)
        {
            index = i;
            break;

        }

    }
    return index;
}





