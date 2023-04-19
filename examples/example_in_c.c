#include <string.h>
#include <stdio.h>
#include "iapws.h"

int main(int argc, char **argv){

    double T = 25.0; /* in C*/
    char *gas = "O2";
    char *solvent = "H2O";
    double kh;
    
    if(argc > 1 ){
        printf("%s\n", argv[1]);
    }

    kh = iapws_capi_kh(T, gas, solvent, strlen(gas), strlen(solvent));
    printf("Gas=%s\tT=%f°C\tkh=%+10.4f\n", gas, T, kh);
    
    return 0;
}
