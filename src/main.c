/**
 *@file main.c
 */
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "iapws.h"
#include "main.h"

static char docstring[] = "Usage: iapws GAS TEMPERATURE [D2O]\n"
        "IAPWS Computation of solubility in water.\n"
        "Supported gases in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6.\n";

/**
 * \brief Start program.
 *
 * Usage: iapws GAS TEMPERATURE [SOLVENT] [PRINT]
 *
 * IAPWS Computation of solubility in H2O and in D2O.
 *
 * Supported gases in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6.\n
 *
 * \return EXIT_SUCCESS.
 */
int main(int argc, char **argv)
{
    int heavywater=0;
    int print = 0;
    int wrong_argument=0;

    if (argc>=3)
    {
        if (argc==4)
        {
            if (strcmp(argv[3], "D2O")==0)
            {
                heavywater = 1;
            }
            else if (strcmp(argv[3], "H2O")==0)
            {
                heavywater = 0;
            }
            else if (strcmp(argv[3], "PRINT")==0)
            {
                print = 1;
            }
            else
            {
                printf("Warning: %s is not an available solvent. Switiching back to H2O\n", argv[3]);
                heavywater = 0;
            }
        }
        else if (argc==5)
        {
            if (strcmp(argv[4], "PRINT")==0) {print = 1;}
        }

    }
    else
    {
        wrong_argument = 1;
    }

    if (wrong_argument)
    {
        printf("%s", docstring);
    }
    else
    {
        solubility(argv[1], strtod(argv[2], NULL), heavywater, print);
    }

    return 0;
}