#include <string.h>
#include <stdio.h>
#include "ciapws.h"

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
    printf("version %s\n", ciapws_get_version());
    
    printf("%s\n", "########################## IAPWS R2-83 ##########################");
    printf("%s %10.3f %s\n", "Tc in H2O", ciapws_r283_tc_h2o, "K");
    printf("%s %10.3f %s\n", "pc in H2O", ciapws_r283_pc_h2o, "MPa");
    printf("%s %10.3f %s\n", "rhoc in H2O", ciapws_r283_rhoc_h2o, "kg/m3");
    
    printf("%s %10.3f %s\n", "Tc in D2O", ciapws_r283_tc_d2o, "K");
    printf("%s %10.3f %s\n", "pc in D2O", ciapws_r283_pc_d2o, "MPa");
    printf("%s %10.3f %s\n", "rhoc in D2O", ciapws_r283_rhoc_d2o, "kg/m3");
    
    printf("\n");


    printf("%s\n", "########################## IAPWS G7-04 ##########################");
    /* Compute kh and kd in h2o*/
    ciapws_g704_kh(&T, gas, heavywater, &kh, strlen(gas), 1);
    printf("Gas=%s\tT=%fC\tkh=%+10.4f\n", gas, T, kh);
    
    ciapws_g704_kd(&T, gas, heavywater, &kd, strlen(gas), 1);
    printf("Gas=%s\tT=%fC\tkd=%+15.4f\n", gas, T, kd);

    /* Get and print the available gases */
    ngas = ciapws_g704_ngases(heavywater);
    gases_list = ciapws_g704_gases(heavywater);
    gases_str = ciapws_g704_gases2(heavywater);
    printf("Gases in H2O: %d\n", ngas);
    printf("%s\n", gases_str);
    for(i=0; i<ngas; i++){
        printf("%s\n", gases_list[i]);
    }
    
    heavywater = 1;
    ngas = ciapws_g704_ngases(heavywater);
    gases_list = ciapws_g704_gases(heavywater);
    gases_str = ciapws_g704_gases2(heavywater);
    printf("Gases in D2O: %d\n", ngas);
    printf("%s\n", gases_str);
    for(i=0; i<ngas; i++){
        printf("%s\n", gases_list[i]);
    }

    return 0;
}
