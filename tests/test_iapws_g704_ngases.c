#include <stdio.h>
#include "iapws_g704.h"


int main(void){

    int value;
    int expected;
    int diff;
    int heavywater;


    printf("***** Test ngases in water *****\n");
    heavywater = 0;
    expected = 14;
    value = iapws_g704_capi_ngases(heavywater);
    diff = value - expected;
    printf("%d/%d/%d\t\n", value, expected, diff);
    if(diff != 0){
        return 1;
    }
    
    printf("***** Test ngases in heavywater *****\n");
    heavywater = 1;
    expected = 7;
    value = iapws_g704_capi_ngases(heavywater);
    diff = value - expected;
    printf("%d/%d/%d\t\n", value, expected, diff);
    if(diff != 0){
        return 1;
    }

}
