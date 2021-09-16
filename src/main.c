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
        {"print_coefficients", 'p', 0, 0, "Print the ABC and ai, bi coefficients"},
        {"test", 't', 0, 0, "Test computations. When this option is selected all arguments are ignored."},
        {0}
};

struct arguments{
    char *args[2];
    int print;
    int heavywater;
    int test;
};

static error_t parse_opt(int key, char *arg, struct argp_state *state){
    struct arguments *arguments = state->input;
    switch(key){
            case 'd':
                    arguments->heavywater = 1;
                    break;
            case 'p':
                    arguments->print = 1;
                    break;
            case 't':
                    arguments->test = 1;
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

    struct arguments arguments;
    arguments.print = 0;
    arguments.test  = 0;
    arguments.heavywater = 0;
    arguments.args[0] = default_gas;
    arguments.args[1] = default_temp;

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if(arguments.test)
    {
        test_water();
        test_heavywater();
    }else{
         solubility(arguments.args[0], strtod(arguments.args[1], NULL), arguments.heavywater, arguments.print);
    }


    EXIT_SUCCESS;
}
