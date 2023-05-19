#include <string.h>
#include <stdio.h>
#include "iapws_g704.h"

int main(int argc, char **argv){

    double T = 25.0; /* in C*/
    char *gas = "O2";
    double kh, kd;
    
    if(argc > 1 ){
        printf("%s\n", argv[1]);
    }

    iapws_g704_capi_kh(&T, gas, 0, &kh, strlen(gas), 1);
    printf("Gas=%s\tT=%fC\tkh=%+10.4f\n", gas, T, kh);
    
    iapws_g704_capi_kd(&T, gas, 0, &kd, strlen(gas), 1);
    printf("Gas=%s\tT=%fC\tkd=%+15.4f\n", gas, T, kd);
    
    return 0;
}
