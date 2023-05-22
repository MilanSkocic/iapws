#include <stdio.h>
#include <string.h>
#include <math.h>
#include "iapws_g704.h"

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
static double ref_kh[14][4] = {{2.6576, 2.1660, 1.1973, -0.1993},
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
static double ref_kd[14][4] = {{15.2250, 10.4364, 6.9971, 3.8019},
                              {15.0743, 10.6379, 7.4116, 4.2308},
                              {13.9823, 10.0558, 6.9869, 3.9861},
                              {13.3968, 9.7362, 6.8371, 3.9654},
                              {12.8462, 9.4268, 6.3639, 3.3793},
                              {14.5286, 10.1484, 6.8948, 3.7438},
                              {14.7334, 10.6221, 7.2923, 4.0333},
                              {14.0716, 10.1676, 6.9979, 3.8707},
                              {14.3276, 10.2573, 7.1218, 4.0880},
                              {10.8043, 7.7705, 5.2123, 2.7293},
                              {9.6846, 6.5840, 4.2781, 2.2200},
                              {13.9659, 10.0819, 6.8559, 3.7238},
                              {13.7063, 10.1510, 6.8453, 3.6493},
                              {15.7067, 11.9887, 8.5550, 4.9599}};
static char *gases[] = {"He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"}; /**< Gases for water */
static double T_K[4] = {300.0, 400.0, 500.0, 600.0};

int main(int argc, char **argv){

    if(argc > 1){
        printf("%s\n", argv[1]);
    }
    double T_C;
    double kh = 0.0;
    double kd = 0.0;
    int D2O = 0;
    double diff;
    int i, j;
    int ngas = 14;
    int nT = 4;

    printf("***** Test kH in water *****\n");

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
    
    printf("***** Test kd in water *****\n");
    
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
