#include <stdio.h>
#include <string.h>
#include <math.h>
#include "iapws.h"

#define T_KELVIN 273.16
#define Vm (0.02241396954*1e6)
#define Tc1_water 647.896
#define pc1_water 22.064
#define Tc1_heavywater 643.847
#define pc1_heavywater 21.671
#define Ms (1.0078250321*2+15.9949146221)

static char *available_gases[] = {"He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"};
static double M_gases[14] = {4.002602, 20.1797, 39.948, 83.798, 131.293, 2.01588, 28.0134, 31.9988, 28.0101, 44.0095, 34.08088, 16.04246, 30.06904, 146.0554192};
enum {A, B, C, Tmin, Tmax};

static int ni_water = 6;
static double ai_water[6] = {-7.85951783, 1.84408259, -11.78664970, 22.68074110, -15.96187190, 1.80122502};
static double bi_water[6] = {1.000, 1.500, 3.000, 3.500, 4.000, 7.500};

static int ni_heavywater = 5;
static double ai_heavy_water[5] = {-7.8966570, 24.7330800, -27.8112800, 9.3559130, -9.2200830};
static double bi_heavy_water[5] = {1.00, 1.89, 2.00, 3.00, 3.60};


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
                             {-16.56118, 2.15289, 20.35440, 283.14, 505.55}};


void solubility(char *gas, double T_C, int heavywater)
{
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

    ix = find(gas, available_gases, 14);

    if (ix < 0)
    {
        printf("Error. %s was not found in the list of available gases.", gas);

    }
    else
    {
       if (heavywater)
        {
            Tr = T_K/Tc1_heavywater;
        }
        else
        {
            Tr = T_K/Tc1_water;
        }

        tau  = 1-Tr;
        ln_kH_pstar = abc_water[ix][A]/Tr + abc_water[ix][B]*pow(tau,0.355)/Tr + abc_water[ix][C]*exp(tau)*pow(Tr,-0.41);

        if (heavywater)
        {
            for (i=0; i<5;i++)
            {

                res = res + ai_heavy_water[i]*pow(tau, bi_heavy_water[i]);
            }
        }
        else
        {
            for (i=0; i<6;i++)
            {
                res = res + ai_water[i]*pow(tau, bi_water[i]);
            }
        }


        ln_pstar_pcl = 1/Tr * res;

        if (heavywater)
        {
             pstar = exp(ln_pstar_pcl)*pc1_heavywater;

        }
        else
        {

            pstar = exp(ln_pstar_pcl)*pc1_water; //MPa

        }

        kH = exp(ln_kH_pstar)*pstar/1000.0;
        x2 = 1.0/kH; // mole fraction per GPa
        cm3_per_kg_per_bar = (x2 / 1e4) * Vm / (Ms*1e-3);
        ppm = cm3_per_kg_per_bar * M_gases[ix]*1e3 / Vm;


        printf("Gas = %s at T = %.1f C\n", gas, T_C);
        printf("ln(kH in GPa) = %f\n", log(kH));
        printf("kH = %f GPa\n", kH);
        printf("x2 = 1/kH = %f GPa-1\n", x2);
        printf("S = %f cm3.kg-1.bar-1\n", cm3_per_kg_per_bar);
        printf("S = %f ppm.bar-1\n", ppm);
    }

}

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




