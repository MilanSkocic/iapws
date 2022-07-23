/**
 * @file test_utilities.c
 * @brief Test utilties functions
 * 
 * @details Test water and heavywater formulas
 * 
 * Author: Milan Skocic <milan.skocic@gmail.com>
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include "utilities.h"



int main(int argc, char **argv){
    
    double value = 0.0356655422;
    double computed;
    double expected = 0.036;
    double d;

    computed = roundn(value, 3);
    d = roundn(computed - expected, 3);
    printf("Computed/Expected/Difference: %f/%f/%.16e\n", computed, expected, d);

    if(d){
        return EXIT_FAILURE;
    }
    
    value = 1001.36;
    computed = roundn(value, 0);
    expected = 1001.0;
    d = roundn(computed - expected, 0);
    printf("Computed/Expected/Difference: %f/%f/%.16e\n", computed, expected, d);

    if(d){
        return EXIT_FAILURE;
    }

    const char *list[] = {"a", "b", "c"};
    char item[] = "b";
    int expected_index = 1;
    int found_index = find(item, list, 3);
    printf("Found index/Expected index %d/%d\n", found_index, expected_index);
    if(found_index != expected_index){
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS; 
}

