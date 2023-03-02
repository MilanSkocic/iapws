#include <stdio.h>
#include <string.h>
#include <math.h>
#include "iapws.h"

 /**
 * @brief Round with n decimals
 * @param x Value to be rounded
 * @param n Number of decimals
 * @return Rounded x
 */
static double roundn(double x, int n){

    double fac;
    double rounded_x;
    fac = pow(10, n);
    rounded_x = round(x*fac)/fac;
    return rounded_x;

}

// data copied directly from PDF of the paper
// Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
// in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
static double ref_kh_water[14][4] = {{2.6576, 2.1660, 1.1973, -0.1993},
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


// data copied directly from PDF of the paper
// Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
// in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
static double ref_kh_heavywater[7][4] = {{2.5756, 2.1215, 1.2748, -0.0034},
                            {2.4421, 2.2525, 1.5554, 0.4664},
                            {1.3316, 1.7490, 1.1312, 0.0360},
                            {0.8015, 1.4702, 0.9505, -0.0661},
                            {0.2750, 1.1251, 0.4322, -0.8730},
                            {1.6594, 1.6762, 0.9042, -0.3665},
                            {1.3624, 1.7968, 1.0491, -0.2186}};

static const char *available_gases_water[] = {"He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"}; /**< Gases for water */
static const char *available_gases_heavywater[] = {"He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"};

static double T_K[4] = {300.0, 400.0, 500.0, 600.0};

int main(int argc, char **argv){

    // loop over all temperature and gases for testing the values rounded to 4
    double T_C;
    double kh = 0.0;
    int status = 0;
    char solvent[] = "H2O";
    size_t i, j;

    for(i=0; i<4; i++){
        printf("%10.1fK\t", T_K[i]);
    }
    printf("\n");

    for(j=0; j<14; j++){
        for(i=0;i<4;i++){
            T_C = T_K[i] - 273.15;
            iapws_capi_kh(T_C, "Ne", solvent, &kh, &status, 
                        strlen("Ne"), strlen(solvent));
            printf("%11.4f\t", log(kh));
        }
        printf("\n");
    }
    printf("\n");
    return 0;
}