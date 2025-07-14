#include <string.h>
#include <stdio.h>
#include "iapws.h"

int main(void){

    double T = 25.0 + 273.15; /* in C*/
    double p; /* p in Mpa */
    char *gas = "O2";
    double kh, kd, wp_res;
    char **gases_list;
    char *gases_str;
    int ngas;
    int i;
    int heavywater = 0;
    double x[3]= {8.0, 4.0, 6.0 };
    double y[3] = {553.15, 1200.0, 2000.0};
    int r[3];
    char s[3];
    
    printf("%s\n", "########################## IAPWS VERSION ##########################");
    printf("version %s\n", iapws_get_version());
    
    printf("%s\n", "########################## IAPWS R2-83 ##########################");
    printf("%s %10.3f %s\n", "Tc in H2O", iapws_r283_Tc_H2O, "K");
    printf("%s %10.3f %s\n", "pc in H2O", iapws_r283_pc_H2O, "MPa");
    printf("%s %10.3f %s\n", "rhoc in H2O", iapws_r283_rhoc_H2O, "kg/m3");
    
    printf("%s %10.3f %s\n", "Tc in D2O", iapws_r283_Tc_D2O, "K");
    printf("%s %10.3f %s\n", "pc in D2O", iapws_r283_pc_D2O, "MPa");
    printf("%s %10.3f %s\n", "rhoc in D2O", iapws_r283_rhoc_D2O, "kg/m3");
    
    printf("\n");


    printf("%s\n", "########################## IAPWS G7-04 ##########################");
    /* Compute kh and kd in H2O*/
    iapws_g704_kh(&T, gas, heavywater, &kh, strlen(gas), 1);
    printf("Gas=%s\tT=%fK\tkh=%+10.4f\n", gas, T, kh);
    
    iapws_g704_kd(&T, gas, heavywater, &kd, strlen(gas), 1);
    printf("Gas=%s\tT=%fK\tkd=%+15.4f\n", gas, T, kd);

    /* Get and print the available gases */
    ngas = iapws_g704_ngases(heavywater);
    gases_list = iapws_g704_gases(heavywater);
    gases_str = iapws_g704_gases2(heavywater);
    printf("Gases in H2O: %d\n", ngas);
    printf("%s\n", gases_str);
    for(i=0; i<ngas; i++){
        printf("%s\n", gases_list[i]);
    }
    
    heavywater = 1;
    ngas = iapws_g704_ngases(heavywater);
    gases_list = iapws_g704_gases(heavywater);
    gases_str = iapws_g704_gases2(heavywater);
    printf("Gases in D2O: %d\n", ngas);
    printf("%s\n", gases_str);
    for(i=0; i<ngas; i++){
        printf("%s\n", gases_list[i]);
    }
    
    printf("%s\n", "########################## IAPWS R7-97 ##########################");
    double Ts[7] =  {-1.0, 25.0, 100.0, 200.0, 300.0, 360.0, 374.0};
    double ps[7] = {1.0, 1.0, 1.0, 1.0, 1.0, 1.0, 1.0};
    for(i=0; i<7; i++){
        Ts[i] = Ts[i] + 273.15;
    }
    iapws_r797_psat(7, Ts, ps);

    for(i=0; i<7; i++){
        printf("%+23.3f %s %+23.3f %s\n", Ts[i], "K", ps[i], "MPa");
    }

    iapws_r797_Tsat(7, ps, Ts);
    for(i=0; i<7; i++){
        printf("%+23.3f %s %+23.3f %s\n", Ts[i], "K", ps[i], "MPa");
    }

    T = 273.15 + 280.0;
    p = 8.0;
    iapws_r797_wp(&p, &T, "v", &wp_res, 1, 1);
    printf("v(8MPa,280°C) = %+23.16f L/kg\n", wp_res * 1000.0);
    
    iapws_r797_wr(x, y, r, 3);
    iapws_r797_wph(x, y, s, 3);
    for(i=0; i<3; i++){
        printf("%i", r[i]);
    }
    printf("\n");
    for(i=0; i<3; i++){
        printf("%c", s[i]);
    }
    printf("\n");

    return 0;
}
