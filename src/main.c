#include "main.h"

int main(int argc, char **argv)
{
    char docstring[] = "Usage: iapws GAS TEMPERATURE\n"
        "IAPWS Computation of solubility in water.\n"
        "Supported gases in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6.\n";

    int i=0;
    double T_C=25;
    double T_K=25+T_KELVIN;
    char gas[8] = "Ar";
    char *available_gases[] = {"He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2", "CO", "CO2", "H2S", "CH4", "C2H6", "SF6"};
    enum {He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6};
    enum {A, B, C, Tmin, Tmax};

    double abc_water[5][5] = {{-3.52839, 7.12983, 4.47770, 273.21, 553.18},
                             {-3.18301, 5.31448, 5.43774, 273.20, 543.36},
                             {-8.40954, 4.29587, 10.52779, 273.19, 568.36},
                             {-8.97358, 3.61508, 11.29963, 273.19, 525.56},
                             {-14.21635, 4.00041, 15.60999, 273.22, 574.85}};



    if (argc==3)
    {
        strcpy(gas, argv[1]);
        T_C = strtod(argv[2], NULL);
        T_K = convert_to_kelvin(T_C);
        printf("Gas=%s - T=%f", gas, T_C);
    }
    else
    {
        printf("%s", docstring);
    }

    return 0;
}