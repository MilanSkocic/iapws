#include <stdio.h>
#include "iapws_g704.h"


int main(void){

    char *value;
    int heavywater;

    printf("***** C Test gases str in water *****\n");
    heavywater = 0;
    value = iapws_g704_capi_gases2(heavywater);
    printf("%s\n", value);
    
    printf("***** C Test gases str in heavywater *****\n");
    heavywater = 1;
    value = iapws_g704_capi_gases2(heavywater);
    printf("%s\n", value);
    
}
