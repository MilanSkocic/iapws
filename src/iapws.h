/**
 * @file iapws.h
 * @brief C header for the IAPWS libary.
 * @example example_in_c.c
 */

#ifndef IAPWS_H
#define IAPWS_H

/** 
 * @brief Compute the henry constante for a given temperature and gas in solvent 
 * @param[in] T Temperature in °C.
 * @param[in] gas Gas.
 * @param[in] solvent Solvents: H2O or D2O. Default is H2O.
 * @param[in] size_gas Length of gas string
 * @param[in] size_solvent Length of solvent string
 * @return kh Henry constante in mole fraction per GPa. NaN if gas not found.
 */
extern double iapws_capi_kh(double T, char *gas, char *solvent, int size_gas, int size_solvent);

#endif