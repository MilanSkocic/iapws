#include <string.h>
#include <stdio.h>
#include "iapws_g704.h"

int main(void){

    double T = 25.0; /* in C*/
    char *gas = "O2";
    double kh, kd;
    char **gases;
    int ngas;
    int i;
    int heavywater = 0;
    
    /* Compute kh and kd for H2O*/
    iapws_g704_capi_kh(&T, gas, heavywater, &kh, strlen(gas), 1);
    printf("Gas=%s\tT=%fC\tkh=%+10.4f\n", gas, T, kh);
    
    iapws_g704_capi_kd(&T, gas, heavywater, &kd, strlen(gas), 1);
    printf("Gas=%s\tT=%fC\tkd=%+15.4f\n", gas, T, kd);

    /* Get and print the available gases */
    printf("Gases in H2O\n");
    ngas = iapws_g704_capi_ngas(heavywater);
    gases = iapws_g704_capi_gases(heavywater);
    for(i=0; i<ngas; i++){
        printf("%s ", gases[i]);
    }
    printf("\n");
    
    printf("Gases in D2O\n");
    heavywater = 1;
    ngas = iapws_g704_capi_ngas(heavywater);
    gases = iapws_g704_capi_gases(heavywater);
    for(i=0; i<ngas; i++){
        printf("%s ", gases[i]);
    }
    printf("\n");
    return 0;
}
