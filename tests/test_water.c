#include <stdio.h>
#include <string.h>
#include <math.h>
#include "iapws.h"

 /**
 * @brief Round with n decimals
 * @param x Value to be rounded
 * @param n Number of decimals
 * @return Rounded x
 */
static double roundn(double x, int n){

    double fac;
    double rounded_x;
    fac = pow(10, n);
    rounded_x = round(x*fac)/fac;
    return rounded_x;

}

int main(int argc, char **argv){

    // loop over all temperature and gases for testing the values rounded to 4
    double T_K[4] = {300.0, 400.0, 500.0, 600.0};
    double T_C;
    double kh = 0.0;
    int status = 0;
    char gas[]= "He";
    char solvent[] = "H2O";
    size_t i;

    for(i=0; i<4; i++){
        printf("%10.1fK\t", T_K[i]);
    }
    printf("\n");

    for(i=0; i<4; i++){
        T_C = T_K[i] - 273.15;
        iapws_capi_kh(T_C, gas, solvent, &kh, &status, strlen(gas), strlen(solvent));
        printf("%11.4f\t", log(kh));
    }
    printf("\n");
    return 0;
}