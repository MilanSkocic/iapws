/**
 *@file main.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "iapws.h"
#include "main.h"

static char docstring[] = "Usage: iapws GAS TEMPERATURE\n"
        "IAPWS Computation of solubility in water.\n"
        "Supported gases in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6.\n";

/**
 * \brief Start program.
 *
 * Usage: iapws GAS TEMPERATURE
 *
 * IAPWS Computation of solubility in water.
 *
 * Supported gases in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6.\n
 *
 * \return EXIT_SUCCESS.
 */
int main(int argc, char **argv)
{

    if (argc==3)
    {
        solubility(argv[1], strtod(argv[2], NULL), 0);
    }
    else
    {
        printf("%s", docstring);
    }



    return 0;
}