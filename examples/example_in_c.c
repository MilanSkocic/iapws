#include <string.h>
#include <stdio.h>
#include "iapws.h"

int main(int argc, char **argv){

    double T = 25.0; /* in C*/
    char *gas = "O2";
    char *solvent = "H2O";
    double kh, kd;
    
    if(argc > 1 ){
        printf("%s\n", argv[1]);
    }

    kh = iapws_capi_kh(T, gas, solvent, strlen(gas), strlen(solvent));
    printf("Gas=%s\tT=%fC\tkh=%+10.4f\n", gas, T, kh);
    
    kd = iapws_capi_kd(T, gas, solvent, strlen(gas), strlen(solvent));
    printf("Gas=%s\tT=%fC\tkd=%+15.4f\n", gas, T, kd);
    
    return 0;
}
