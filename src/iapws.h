/**
 * @file iapws.h
 * @example example_in_c.c
 */


/** 
 * @brief Compute the henry constante for a given temperature and gas in solvent 
 * @param[in] T Temperature in °C.
 * @param[in] gas Gas.
 * @param[in] solvent Solvents: H2O or D2O. Default is H2O.
 * @param[out] kh Henry constante in mole fraction per GPa. NaN if status > 0.
 * @param[out] status 0: no error, 1: gas not found, 2: T out of bounds.
 * @param[in] size_gas Length of gas string
 * @param[in] size_solvent Length of solvent string
 */
extern void iapws_capi_kh(double T, char *gas, char *solvent, 
                          double *kh, int *status, int size_gas, int size_solvent);