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
    char **gases_list_D2O;
    int diff_gas_H2O[14] = {0, 0, 0, 0, 0, 0 ,0, 0, 0, 0, 0, 0, 0, 0};
    int diff_gas_D2O[7] = {0, 0, 0, 0, 0, 0 ,0};
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
    s=0;
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
        exit(1);
    }
    
    printf("    %s", "gases in heavywater...");
    heavywater = 1;
    gases_list_D2O = iapws_g704_capi_gases(heavywater);
    for(i=0; i<7; i++){
        if(strcmp(gases_list_D2O[i], expected_gases_D2O[i]) == 0){
            diff_gas_D2O[i] = 1;
        }else{
            diff_gas_D2O[i] = 0;
        }
    }
    s=0;
    for(i=0; i<7; i++){
        s = s + diff_gas_D2O[i];
    }
    if(s == 7){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        for(i=0; i<7; i++){
            printf("    %s    %s    %d\n", gases_list_D2O[i], expected_gases_D2O[i], diff_gas_D2O[i]);
        }
        exit(1);
    }
}

void test_gases2(void){

    int heavywater;
    char expected_gases_str_H2O[] = "He,Ne,Ar,Kr,Xe,H2,N2,O2,CO,CO2,H2S,CH4,C2H6,SF6";
    char expected_gases_str_D2O[] = "He,Ne,Ar,Kr,Xe,D2,CH4";
    char *gases_str;

    printf("    %s", "gases2 in water...");
    heavywater = 0;
    gases_str = iapws_g704_capi_gases2(heavywater);
    if(strcmp(gases_str, expected_gases_str_H2O)==0){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        printf("    %s\n", gases_str);
        printf("    %s\n", expected_gases_str_H2O);
    }
    
    printf("    %s", "gases2 in heavywater...");
    heavywater = 1;
    gases_str = iapws_g704_capi_gases2(heavywater);
    if(strcmp(gases_str, expected_gases_str_D2O)==0){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        printf("    %s\n", gases_str);
        printf("    %s\n", expected_gases_str_D2O);
    }

}

void test_kh(void){
    
    // test only one value to check that C API works
    // all values are tested in the Fortran test
    int heavywater;
    double value;
    double expected;
    double diff;
    double T = 300.0 - 273.15;

    printf("    %s", "kh in water...");
    heavywater = 0;
    expected = 2.6576;
    iapws_g704_capi_kh(&T, "He", heavywater, &value, 2, 1);
    value = log(value / 1000.0);
    diff = value - expected;
    if(assertEqual(diff, 0.0, 4)){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        printf("    %s %+3.0f    %+7.4f/%+7.4f/%+7.4f\n", "He", T+273.15, value, expected, diff);
        exit(1);
    }
    
    printf("    %s", "kh in heavywater...");
    heavywater = 1;
    expected = 2.5756;
    iapws_g704_capi_kh(&T, "He", heavywater, &value, 2, 1);
    value = log(value / 1000.0);
    diff = value - expected;
    if(assertEqual(diff, 0.0, 4)){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        printf("    %s %+3.0f    %+7.4f/%+7.4f/%+7.4f\n", "He", T+273.15, value, expected, diff);
        exit(1);
    }

}

void test_kd(void){
    
    // test only one value to check that C API works
    // all values are tested in the Fortran test
    int heavywater;
    double value;
    double expected;
    double diff;
    double T = 300.0 - 273.15;

    printf("    %s", "kd in water...");
    heavywater = 0;
    expected = 15.2250;
    iapws_g704_capi_kd(&T, "He", heavywater, &value, 2, 1);
    value = log(value);
    diff = value - expected;
    if(assertEqual(diff, 0.0, 4)){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        printf("    %s %+3.0f    %+7.4f/%+7.4f/%+7.4f\n", "He", T+273.15, value, expected, diff);
        exit(1);
    }
    
    printf("    %s", "kd in heavywater...");
    heavywater = 1;
    expected = 15.2802;
    iapws_g704_capi_kd(&T, "He", heavywater, &value, 2, 1);
    value = log(value);
    diff = value - expected;
    if(assertEqual(diff, 0.0, 4)){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        printf("    %s %+3.0f    %+7.4f/%+7.4f/%+7.4f\n", "He", T+273.15, value, expected, diff);
        exit(1);
    }

}

void test_isnull_terminated(void){
    char *gases;
    int heavywater;
    int i, n;

    printf("    %s", "is null terminated in water...");
    heavywater = 0;
    gases = iapws_g704_capi_gases2(heavywater);
    n = strlen(gases);
    if((gases[n] == '\0') & (gases[n-1] == '6')){
        printf("%s\n", "OK");
    }else{
        printf("%s\n", "Failed");
        printf("    %s\n", gases);
        exit(1);
    }

}

int main(void){

    printf("%s\n", "***** TESTING C API CODE FOR G704 *****");
    test_ngases();
    test_gases();
    test_isnull_terminated();
    test_gases2();
    test_kh();
    test_kd();
    return EXIT_SUCCESS;
}