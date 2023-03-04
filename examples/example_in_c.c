#include <string.h>
#include <stdio.h>
#include "iapws.h"

int main(int argc, char **argv){

    double T = 25.0; /* in C*/
    char *gas = "O2";
    char *solvent = "H2O";
    double kh, Scm3, Sppm;
    
    if(argc > 1 ){
        printf("%s\n", argv[1]);
    }

    kh = iapws_capi_kh(T, gas, solvent, strlen(gas), strlen(solvent));
    Scm3 = iapws_capi_scm3(T, gas, solvent, strlen(gas), strlen(solvent));
    Sppm = iapws_capi_sppm(T, gas, solvent, strlen(gas), strlen(solvent));
    printf("Gas=%s\tT=%f°C\tkh=%+10.4f\n", gas, T, kh);
    printf("Gas=%s\tT=%f°C\tS=%+10.4f cm3.kg-1.bar-1\n", gas, T, Scm3);
    printf("Gas=%s\tT=%f°C\tS=%+10.4f ppm.bar-1\n", gas, T, Sppm);
    
    return 0;
}
