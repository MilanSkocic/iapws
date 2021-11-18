/**
 *@file main.c
 * @author M. Skocic
 * @brief Compute the solubility constants for 14 gases in water and 7 gases in heavy water.
 * @date 2020/08/04
 */
#include "iapws.h"
#include "argp.h"

const char *argp_program_version = "iapws 1.0";

const char *argp_program_bug_address = "<milan.skocic@gmail.com>";

static char doc[] =  "\t IAPWS Computation of solubility in water.\n"
                     "\t Supported gases in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6.\n"
                     "\t Supported gases in heavywater: He, Ne, Ar, Kr, Xe, D2, CH4\n";

static char args_doc[] = "GAS TEMPERATURE";

static struct argp_option options[] = {
        {"heavywater", 'd', 0, 0, "Set solvent to heavywater"},
        {"print_coefficients", 'c', 0, 0, "Print the ABC and ai, bi coefficients"},
        {"test", 't', 0, 0, "Test computations. When this option is selected all arguments are ignored."},
        {"verbose", 'v', 0, 0, "Verbose output: ln(kH) and kH"},
        {"solubility", 's', "sol_unit", OPTION_ARG_OPTIONAL, "Specify the solubility unit: ppm, cm3, gpa, all."},
        {"pressure", 'p', "pressure", OPTION_ARG_OPTIONAL, "Set pressure value in bar."},
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
    if(arguments.test)
    {
        test_water();
        test_heavywater();
    }else{
         solubility(arguments.args[0], strtod(arguments.args[1], NULL), 
                    arguments.heavywater, 
                    arguments.print, 
                    arguments.solubility,
                    arguments.pressure,
                    arguments.verbose);
    }


    EXIT_SUCCESS;
}
