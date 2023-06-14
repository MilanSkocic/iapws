#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>
#include "iapws_g704.h"


static double roundn(double x, int n){
    double fac;
    double rounded_x;
    fac = pow(10, n);
    rounded_x = round(x*fac)/fac;
    return rounded_x;
}

static int assertEqual(double x1, double x2, int n){
    int r;

    double fac;
    double ix1, ix2;

    fac = pow(10, n);
    ix1 = round(x1 * fac);
    ix2 = round(x2 * fac);

    r = ix1 == ix2;

    return r;
}

void test_ngases(void){

    int value;
    int expected;
    int diff;
    int heavywater;

    printf("    %s", "ngases in water...");
    heavywater = 0;
    expected = 14;
    value = iapws_g704_capi_ngases(heavywater);
    diff = value - expected;
    if(diff != 0){
        printf("%s", "Failed");
        printf("    %d%s%d%s%d\n", value, "/", expected, "/", diff);
        exit(1);
    }else{
        printf("%s\n", "OK");
    }
    
    printf("    %s", "ngases in heavywater...");
    heavywater = 1;
    expected = 7;
    value = iapws_g704_capi_ngases(heavywater);
    diff = value - expected;
    if(diff != 0){
        printf("%s", "Failed");
        printf("    %d%s%d%s%d\n", value, "/", expected, "/", diff);
        exit(1);
    }else{
        printf("%s\n", "OK");
    }
}

void test_gases(void){

    int heavywater;
    int i;
    char *expected_gases_H2O[14] = {"He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"};
    char *expected_gases_D2O[7] = {"He", "Ne", "Ar", "Kr", "Xe", "D2", "CH4"};
    char **gases_list_H2O;
    int diff_gas_H2O[14] = {0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0, 0, 0, 0};
    int s=0;
    
    printf("    %s", "gases in water...");
    heavywater = 0;
    gases_list_H2O = iapws_g704_capi_gases(heavywater);
    for(i=0; i<14; i++){
        if(strcmp(gases_list_H2O[i], expected_gases_H2O[i]) == 0){
            diff_gas_H2O[i] = 1;
        }else{
            diff_gas_H2O[i] = 0;
        }
    }
    for(i=0; i<14; i++){
        s = s + diff_gas_H2O[i];
    }
    if(s == 14){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        for(i=0; i<14; i++){
            printf("    %s    %s    %d\n", gases_list_H2O[i], expected_gases_H2O[i], diff_gas_H2O[i]);
        }
    }
}


int main(void){

    printf("%s\n", "***** TESTING C API CODE FOR G704 *****");
    test_ngases();
    test_gases();
    return EXIT_SUCCESS;
}