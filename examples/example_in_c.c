#include <string.h>
#include <stdio.h>
#include "iapws.h"

int main(int argc, char **argv){

    double T = 300.0-273.15; /* in C*/
    char *gas = "He";
    char *solvent = "H2O";
    double kh;
    int status;
    
    if(argc > 1 ){
        printf("%s\n", argv[1]);
    }

    iapws_capi_kh(T, gas, solvent, &kh, &status, strlen(gas), strlen(solvent));
    printf("Gas=%s\tT=%f°C\tkh=%f\n", gas, T, kh);
    
    return 0;
}