/**
 * @file test_utilites.c
 * @brief Test IAPWS
 * 
 * @details Test water and heavywater formulas
 * 
 * Author: Milan Skocic <milan.skocic@gmail.com>
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "iapws.h"



int main(int argc, char **argv){
    
    double value = 0.0356;
    double computed;
    double expected = 0.037;

    computed = roundn(value, 3);
    
    if((computed == expected)>0.0){
        EXIT_SUCCESS;
    }
    else{EXIT_FAILURE;}

}

