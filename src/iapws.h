#ifndef IAPWS
#define IAPWS

double convert_to_kelvin(double T);
int find(char *item, char **list, int size);
void solubility(char *gas, double T_C, int heavywater, int print);

#endif