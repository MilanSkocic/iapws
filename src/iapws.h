/**
 * @file iapws.h
 * @example example_in_c.c
 */


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

/** 
 * @brief Compute the solubility constant for a given temperature and gas in solvent 
 * @param[in] T Temperature in °C.
 * @param[in] gas Gas.
 * @param[in] solvent Solvents: H2O or D2O. Default is H2O.
 * @param[in] size_gas Length of gas string
 * @param[in] size_solvent Length of solvent string
 * @return Scm3 Solubility constant in cm3.kg-1.bar-1. Nan if gas not found.
 */
extern double iapws_capi_scm3(double T, char *gas, char *solvent, int size_gas, int size_solvent);

/** 
 * @brief Compute the solubility constant for a given temperature and gas in solvent 
 * @param[in] T Temperature in °C.
 * @param[in] gas Gas.
 * @param[in] solvent Solvents: H2O or D2O. Default is H2O.
 * @param[in] size_gas Length of gas string
 * @param[in] size_solvent Length of solvent string
 * @return Sppm Solubility constant in ppm. Nan if gas not found.
 */
extern double iapws_capi_sppm(double T, char *gas, char *solvent, int size_gas, int size_solvent);
