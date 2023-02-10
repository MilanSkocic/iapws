/**
 * @file main.c
 * @author M. Skocic
 * @brief Compute the solubility constants for 14 gases in water and 7 gases in heavy water.
 * 
 * Copyright (C) 2020-2022  Milan Skocic.
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>. 
 *
 *
 * Author: Milan Skocic <milan.skocic@icloud.com>
 */
#include <stdlib.h>
#include "iapws.h"
#include "version.h"
#include "argp.h"

const char *argp_program_version = PROJECT_VERSION;

const char *argp_program_bug_address = "<milan.skocic@gmail.com>";

static char doc[] =  PROJECT_DESCRIPTION;

static char args_doc[] = "GAS TEMPERATURE";

static struct argp_option options[] = {
        {"heavywater", 'd', 0, 0, "Set solvent to heavywater"},
        {"print_coefficients", 'c', 0, 0, "Print the ABC and ai, bi coefficients"},
        {"test", 't', 0, 0, "Test computations. When this option is selected all arguments are ignored."},
        {"verbose", 'v', 0, 0, "Verbose output: ln(kH) and kH"},
        {"solubility", 's', "sol_unit", OPTION_ARG_OPTIONAL, "Specify the solubility unit: ppm, cm3, gpa, all. The default unit is ppm.bar-1"},
        {"pressure", 'p', "pressure", OPTION_ARG_OPTIONAL, "Set pressure value in bar. The returned value is a concentration."},
        {0}
};

struct arguments{
    char *args[2];
    int print;
    int verbose;
    double pressure;
    int kh;
    int heavywater;
    int test;
    char *solubility;
};

static error_t parse_opt(int key, char *arg, struct argp_state *state){
    struct arguments *arguments = state->input;
    switch(key){
            case 'd':
                    arguments->heavywater = 1;
                    break;
            case 'c':
                    arguments->print = 1;
                    break;
            case 't':
                    arguments->test = 1;
                    break;
            case 's':
                    arguments->solubility=arg;
                    break;    
            case 'v':
                    arguments->verbose = 1;
                    break;  
            case 'p':
                    if (arg==NULL){
                            arguments->pressure = 0.0;
                    } 
                    else{
                        arguments->pressure = strtod(arg, NULL);
                    }
                    break;         
            case ARGP_KEY_ARG:
                    if((state->arg_num >=2) & (arguments->test == 0)){
                            argp_usage(state);
                    }else{
                        arguments->args[state->arg_num] = arg;
                    }
                    break;
            case ARGP_KEY_END:
                    if((state->arg_num < 2) & (arguments->test == 0)){
                            argp_usage(state);
                    }
                    break;
            default:
                    return ARGP_ERR_UNKNOWN;
    }
    return 0;
}

static struct argp argp = {options, parse_opt, args_doc, doc};

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
    //initialization
    int i, ix, j=0, run = 1, test=0;
    int stringlen = 256;
    char default_gas[] = "O2";
    char default_temp[] = "25.0";
    char default_solubility[] = "ppm";

    struct arguments arguments;
    arguments.print = 0;
    arguments.verbose = 0;
    arguments.test  = 0;
    arguments.heavywater = 0;
    arguments.pressure = 0.0;
    arguments.args[0] = default_gas;
    arguments.args[1] = default_temp;
    arguments.solubility = default_solubility;

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if (arguments.solubility == NULL){
        arguments.solubility = default_solubility;
    }
    if(arguments.print){
        print_coefficients(arguments.args[0], arguments.heavywater);
    }
    
    if (arguments.test == 1){
        if (arguments.heavywater==1){
                test_heavywater();
        }
        else{
                test_water();
        }
    }
    else{
        solubility(arguments.args[0], strtod(arguments.args[1], NULL), 
                    arguments.heavywater, 
                    arguments.solubility,
                    arguments.pressure,
                    arguments.verbose);
    }
    


    EXIT_SUCCESS;
}
