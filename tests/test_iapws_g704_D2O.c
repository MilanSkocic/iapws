#include <stdio.h>
#include <string.h>
#include <math.h>
#include "iapws_g704_capi.h"

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
static double ref_kh[7][4] = {{2.5756, 2.1215, 1.2748, -0.0034},
                            {2.4421, 2.2525, 1.5554, 0.4664},
                            {1.3316, 1.7490, 1.1312, 0.0360},
                            {0.8015, 1.4702, 0.9505, -0.0661},
                            {0.2750, 1.1251, 0.4322, -0.8730},
                            {1.6594, 1.6762, 0.9042, -0.3665},
                            {1.3624, 1.7968, 1.0491, -0.2186}};

// data copied directly from PDF of the paper
// Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
// in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
static double ref_kd[7][4] = {{15.2802, 10.4217, 7.0674, 3.9539},
                              {15.1473, 10.5331, 7.3435, 4.2800},
                              {14.0517, 10.0632, 6.9498,3.9094},
                              {13.5042, 9.7854, 6.8035, 3.8160},
                              {12.9782, 9.4648, 6.3074, 3.1402},
                              {14.3520, 10.0178, 6.6975, 3.5590},
                              {14.0646, 10.1013, 6.9021, 3.8126}};

static char *gases[] = {"He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"};
static double T_K[4] = {300.0, 400.0, 500.0, 600.0};

int main(int argc, char **argv){

    if(argc > 1){
        printf("%s\n", argv[1]);
    }

    double T_C;
    double kh = 0.0;
    double kd = 0.0;
    int D2O = 1;
    double diff;
    int i, j;
    int ngas = 7;
    int nT = 4;

    printf("***** Test kH in heavywater *****\n");

    printf("%5s\t", "Gas");
    for(i=0; i<nT; i++){
        printf("%23.0f\t", T_K[i]);
    }
    printf("\n");

    for(j=0; j<ngas; j++){
        printf("%5s\t", gases[j]);
        for(i=0;i<4;i++){
            T_C = T_K[i] - 273.15;
            iapws_g704_capi_kh(&T_C, gases[j], D2O, &kh, strlen(gases[j]), 1);
            kh /= 1000.0;
            diff = roundn(log(kh) - ref_kh[j][i], 4);
            printf("%+7.4f/%+7.4f/%+7.4f\t", log(kh), ref_kh[j][i], log(kh) - ref_kh[j][i]);
            if(diff != 0.0){
                return 1;
            }
        }
        printf("\n");
    }
    
    printf("***** Test kd in heavywater *****\n");

    printf("%5s\t", "Gas");
    for(i=0; i<nT; i++){
        printf("%23.0f\t", T_K[i]);
    }
    printf("\n");

    for(j=0; j<ngas; j++){
        printf("%5s\t", gases[j]);
        for(i=0;i<4;i++){
            T_C = T_K[i] - 273.15;
            iapws_g704_capi_kd(&T_C, gases[j], D2O, &kd, strlen(gases[j]), 1);
            diff = roundn(log(kd) - ref_kd[j][i], 4);
            printf("%+7.4f/%+7.4f/%+7.4f\t", log(kd), ref_kd[j][i], log(kd) - ref_kd[j][i]);
            if(diff != 0.0){
                return 1;
            }
        }
        printf("\n");
    }
    return 0;
}
