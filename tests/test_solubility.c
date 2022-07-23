/**
 * @file test_solubility.c
 * @brief Test IAPWS
 * 
 * @details Test water and heavywater formulas
 * 
 * Author: Milan Skocic <milan.skocic@gmail.com>
 */
#include <stdlib.h>
#include "ciapws.h"



int main(int argc, char **argv){
    
    int res = 0;
    res = test_water();

    res = test_heavywater();
    
    return EXIT_SUCCESS;
}





