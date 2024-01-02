#include <string.h>
#include <stdio.h>
#include "iapws.h"

int main(void){

    double T = 25.0; /* in C*/
    char *gas = "O2";
    double kh, kd;
    char **gases_list;
    char *gases_str;
    int ngas;
    int i;
    int heavywater = 0;
    
    printf("%s\n", "########################## IAPWS VERSION ##########################");
    printf("version %s\n", iapws_get_version());
    
    printf("%s\n", "########################## IAPWS R2-83 ##########################");
    printf("%s %10.3f %s\n", "Tc in H2O", iapws_Tc_H2O, "K");
    printf("%s %10.3f %s\n", "pc in H2O", iapws_pc_H2O, "MPa");
    printf("%s %10.3f %s\n", "rhoc in H2O", iapws_rhoc_H2O, "kg/m3");
    
    printf("%s %10.3f %s\n", "Tc in D2O", iapws_Tc_D2O, "K");
    printf("%s %10.3f %s\n", "pc in D2O", iapws_pc_D2O, "MPa");
    printf("%s %10.3f %s\n", "rhoc in D2O", iapws_rhoc_D2O, "kg/m3");
    
    printf("\n");


    printf("%s\n", "########################## IAPWS G7-04 ##########################");
    /* Compute kh and kd in H2O*/
    iapws_g704_capi_kh(&T, gas, heavywater, &kh, strlen(gas), 1);
    printf("Gas=%s\tT=%fC\tkh=%+10.4f\n", gas, T, kh);
    
    iapws_g704_capi_kd(&T, gas, heavywater, &kd, strlen(gas), 1);
    printf("Gas=%s\tT=%fC\tkd=%+15.4f\n", gas, T, kd);

    /* Get and print the available gases */
    ngas = iapws_g704_capi_ngases(heavywater);
    gases_list = iapws_g704_capi_gases(heavywater);
    gases_str = iapws_g704_capi_gases2(heavywater);
    printf("Gases in H2O: %d\n", ngas);
    printf("%s\n", gases_str);
    for(i=0; i<ngas; i++){
        printf("%s\n", gases_list[i]);
    }
    
    heavywater = 1;
    ngas = iapws_g704_capi_ngases(heavywater);
    gases_list = iapws_g704_capi_gases(heavywater);
    gases_str = iapws_g704_capi_gases2(heavywater);
    printf("Gases in D2O: %d\n", ngas);
    printf("%s\n", gases_str);
    for(i=0; i<ngas; i++){
        printf("%s\n", gases_list[i]);
    }

    return 0;
}
