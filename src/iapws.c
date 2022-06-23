/**
 * @file iapws.c
 * @author M. Skocic
 * @brief Compute the solubility constants for 14 gases in water and 7 gases in heavy water.
 * @date 2020/08/04
 * The computation is based on the parameters provided by the IAPWS 2004: @f$ k_H = \lim_{x_2 \rightarrow 0} f_2/x_2 @f$.
 * where @f$f_2@f$ and @f$x_2@f$ are, respectively, the liquid-phase fugacity and mole fraction of the solute.
 * The Henry's constant @f$k_H@f$ is given as a function of temperature by:
 * \f{eqnarray*}{
 * \ln \left( \frac{k_H}{p_1^*} \right) = A/T_R + \frac{B \cdot \tau^{0.355}}{T_R} + C \cdot T_R^{-0.41} \cdot \exp \tau \\
 * \tau = 1-T_R \\
 * T_R = T/T_{c1}
 * \f}
 * @f$T_{c1}@f$ is the critical temperature of the solvent as recommended by IAPWS1997
 * (647.096 for H2O and 643.847 K for D2O) and @f$p_1^*@f$ is the vapor pressure of the
 * solvent at the temperature of interest.
 * @f$p_1^*@f$ is calculated from the correlation of Wagner and Pruss for H2O and from
 * the correlation of Harvey and Lemmon  for D2O.
 * Both equations have the form @f$ \ln \left( p_1^{*}/p_{c1} \right) = T_R^{-1} \sum_{i=1}^{n}a_i \tau^{b_i} @f$
 * where the number of terms n is 6 for  H2O and 5 for D2O , @f$p_{c1}@f$ is the critical
 * pressure of the solvent recommended by IAPWS IAPWS1997 (22.064 MPa for H2O and 21.671 MPa for D2O)
 * The Henry's constant :@f$k_H@f$ has a dimension of pressure expressed here in bars:
 * \f{eqnarray*}{
 * x_2 [\text{mole fraction per bar}] = \frac{1}{k_H}\\
 * wt_2 = \text{molfrac2massfrac}(x_2)\\
 * S [ppm.bar^{-1}] = \text{massfraction2ppm}(wt_2)\\
 * S [cm^3.kg^{-1}.bar^{-1}] = \frac{x_2 \cdot V_m}{M_s}
 * \f}
 *
 * @see [IAPWS2004] Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases in H2O and D2O at High Temperatures », IAPWS, Kyoto, Japan, G7-04, 2004
 * @see [IAPWS1997] Revised Release on the IAPWS Industrial Formulation 1997 for the thermodynamic Properties of Water and Steam, IAPWS, Lucerne Switzerland R7-97, 2012.
 * @see [WagnerPruss] W. Wagner et A. Pruss, « International Equations for the Saturation Properties of Ordinary Water Substance. Revised According to the International Temperature Scale of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987) », Journal of Physical and Chemical Reference Data, vol. 22, n°3, p. 783‑787, mai 1993. <https://doi.org/10.1063/1.555926>
 * @see [HarveyLemmon] A. H. Harvey et E. W. Lemmon, « Correlation for the Vapor Pressure of Heavy Water From the Triple Point to the Critical Point », Journal of Physical and Chemical Reference Data, vol. 31, n°1, p. 173‑181, mars 2002 <https://doi.org/10.1063/1.1430231>
 */
#include "iapws.h"


/** @brief Compute the solubility constants for 14 gases in water and 7 gases in heavy water.
 * Print the result on stdout.
 * @param *gas Gas for which the computation has to be performed.
 * @param T_C Temperature in °C.
 * @param heavywater Flag for selecting heavywater instead of water.
 * @param print Flag for printing coefficients ai, bi, and ABC
 */
void solubility(char *gas, double T_C, int heavywater, int print, char *solubility_unit, double pressure, int verbose)
{
    double Tc1=Tc1_water;
    double pc1=pc1_water;
    double Ms=Ms_water;
    double *abc = abc_water[0];
    double *ai = ai_water;
    double *bi = bi_water;
    double *M_gases = M_gases_water;
    int ni = ni_water;
    int ngas = ngas_water;
    char solvent[] = "H2O";
    char **list_gas = available_gases_water;
    double T_K;
    double kH;
    double x2;
    double cm3_per_kg_per_bar;
    double ppm;
    int i;
    int ix;
    T_K = T_C+T_KELVIN;

    if (T_C == 0.0)
    {
        printf("Warning: Temperature was set to %f C. Check if the correct temperature was entered.\n", T_C);
    }

    if (heavywater)
    {
        Tc1 = Tc1_heavywater;
        pc1 = pc1_heavywater;
        Ms = Ms_heavywater;
        abc = abc_heavywater[0];
        ai = ai_heavy_water;
        bi = bi_heavy_water;
        ni = ni_heavywater;
        ngas = ngas_heavywater;
        list_gas = available_gases_heavywater;
        strcpy(solvent, "D2O");
        M_gases = M_gases_heavywater;
    }
    ix = find(gas, list_gas, ngas);
    if (ix < 0)
    {
        printf("Error. %s was not found in the list of available gases in %s.\n", gas, solvent);
    }
    else
    {
        kH = henry_constant(ix, T_K, Tc1, pc1, ni, ai, bi, abc);
        x2 = 1.0/kH; // mole fraction per GPa
        cm3_per_kg_per_bar = (x2 / 1e4) * Vm / (Ms*1e-3);
        ppm = cm3_per_kg_per_bar * M_gases[ix]*1e3 / Vm;

        if (verbose){
            printf("Gas = %s at T = %.1f C in %s\n", gas, T_C, solvent);
            printf("ln(kH in GPa) = %.4f\n", log(kH));
            printf("kH = %.4f GPa\n", kH);

        }
        
        if(strcmp(solubility_unit, "gpa")==0){
            printf("x2 = 1/kH = %.4f GPa-1\n", x2);
        }
        
        if (strcmp(solubility_unit, "ppm")==0){
            if (pressure){
                printf("S = %.2f ppm\n", ppm*pressure);
            }else{
                printf("S = %.2f ppm.bar-1\n", ppm);
            }
        }

        if (strcmp(solubility_unit, "cm3")==0){
            if(pressure){
                printf("S = %.2f cm3.kg-1\n", cm3_per_kg_per_bar*pressure);
            }
            else{       
                printf("S = %.2f cm3.kg-1.bar-1\n", cm3_per_kg_per_bar);
            }
        }

        if(strcmp(solubility_unit, "all")==0){
            printf("x2 = 1/kH = %.4f GPa-1\n", x2);
            if(pressure){
                printf("S = %.2f ppm\n", ppm*pressure);
                printf("S = %.2f cm3.kg-1\n", cm3_per_kg_per_bar*pressure);
            }
            else{
                printf("S = %.2f ppm.bar-1\n", ppm);
                printf("S = %.2f cm3.kg-1.bar-1\n", cm3_per_kg_per_bar);
            }   

        }

        if (print)
        {
            printf("\n");
            printf("***** ai and bi Coefficients for %s *****\n", gas);
            for (i=0;i<ni;i++)
            {
                printf("a[%d] = %f \t b[%d] = %f\n", i, ai[i], i, bi[i]);
            }

            printf("\n");
            printf("**** ABC Coefficients for %s *****\n", gas);
            printf("A=%f \t B=%f \t C=%f\n\n",  *(abc+ix*abc_ncols+A), *(abc+ix*abc_ncols+B), *(abc+ix*abc_ncols+C));
        }

    }
}



/** @brief Compute the henry constant of a given gas.
 * @param ix Gas index for which the computation has to be performed.
 * @param T_K Temperature in K.
 * @param Tc1 Critical temperature.
 * @param pc1 Critical pressure.
 * @param ni Number of indexes for ai and bi coefficients
 * @param *ai ai coefficients
 * @param *bi bi coefficients
 * @param *abc abc table
 */
double henry_constant(int ix, double T_K, double Tc1, double pc1, int ni, double *ai, double *bi, double *abc)
{
    double Tr;
    double tau;
    double ln_kH_pstar;
    double res;
    double ln_pstar_pcl;
    double pstar;
    double kH;
    int i;

    Tr = T_K/Tc1;
    tau  = 1-Tr;
    ln_kH_pstar = *(abc+ix*abc_ncols+A)/Tr + *(abc+ix*abc_ncols+B)*pow(tau,0.355)/Tr + *(abc+ix*abc_ncols+C)*exp(tau)*pow(Tr,-0.41);

    res = 0.0;
    for (i=0; i<ni;i++)
    {
        res = res + ai[i]*pow(tau, bi[i]);
    }
    ln_pstar_pcl = 1/Tr * res;
    pstar = exp(ln_pstar_pcl)*pc1; //MPa

    kH = exp(ln_kH_pstar)*pstar/1000.0;

    return kH;

}

/**
 * @brief Test the computation of Henry Constant for water.
 */
int test_water()
{
    int cols = 4;
    int i, j;
    double T[4] = {300, 400, 500, 600};
    double kH;
    double ln_kH;

    // data copied directly from PDF of the paper
    // Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
    // in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
    double results[14][4] = {{2.6576, 2.1660, 1.1973, -0.1993},
                        {2.5134, 2.3512, 1.5952, 0.4659},
                        {1.4061, 1.8079, 1.1536, 0.0423},
                        {0.8210, 1.4902, 0.9798, 0.0006},
                        {0.2792, 1.1430, 0.5033, -0.7081},
                        {1.9702, 1.8464, 1.0513, -0.1848},
                        {2.1716, 2.3509, 1.4842, 0.1647},
                        {1.5024, 1.8832, 1.1630, -0.0276},
                        {1.7652, 1.9939, 1.1250, -0.2382},
                        {-1.7508, -0.5450, -0.6524, -1.3489},
                        {-2.8784, -1.7083, -1.6074, -2.1319},
                        {1.4034, 1.7946, 1.0342, -0.2209},
                        {1.1418, 1.8495, 0.8274, -0.8141},
                        {3.1445, 3.6919, 2.6749, 1.2402}};

    printf("\n***** TEST for Water: ln(kH) computed / ln(kH) IPAWS / computed - IAPWS *****\n");
    printf("%4s", "Gas\t");
    for (j=0; j<cols; j++)
    {
        printf("%25dK\t", (int) T[j]);
    }
    printf("\n");
    for (i=0; i<ngas_water; i++)
    {
        printf("%4s\t", available_gases_water[i]);
        for(j=0; j<cols; j++)
        {
            kH = henry_constant(i, T[j], Tc1_water, pc1_water, ni_water, ai_water, bi_water, abc_water[0]);
            ln_kH = roundn(log(kH), 5);
            printf("%+8.4f/%+8.4f/%+8.4f\t", ln_kH, results[i][j], ln_kH - results[i][j]);
        }
        printf("\n");
    }
    return 0;
}

/**
 * @brief Test the computation of Henry Constant for heavywater.
 */
int test_heavywater()
{
    int cols = 4;
    int i, j;
    double T[4] = {300, 400, 500, 600};
    double kH;
    double ln_kH;

    // data copied directly from PDF of the paper
    // Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases
    // in H2O and D2O at High Temperatures » IAPWS, Kyoto, Japan, G7-04, 2004
    double results[14][4] = {{2.5756, 2.1215, 1.2748, -0.0034},
                                {2.4421, 2.2525, 1.5554, 0.4664},
                                {1.3316, 1.7490, 1.1312, 0.0360},
                                {0.8015, 1.4702, 0.9505, -0.0661},
                                {0.2750, 1.1251, 0.4322, -0.8730},
                                {1.6594, 1.6762, 0.9042, -0.3665},
                                {1.3624, 1.7968, 1.0491, -0.2186}};

    printf("\n***** TEST for HeavyWater: ln(kH) computed / ln(kH) IPAWS / computed - IAPWS *****\n");

    printf("%4s", "Gas\t");
    for (j=0; j<cols; j++)
    {
        printf("%25dK\t", (int) T[j]);
    }
    printf("\n");
    for (i=0; i<ngas_heavywater; i++)
    {
        printf("%4s\t", available_gases_water[i]);
        for(j=0; j<cols; j++)
        {
            kH = henry_constant(i, T[j], Tc1_heavywater, pc1_heavywater, ni_heavywater, ai_heavy_water, bi_heavy_water, abc_heavywater[0]);
            ln_kH = roundn(log(kH), 5);
            printf("%+8.4f/%+8.4f/%+8.4f\t", ln_kH, results[i][j], ln_kH - results[i][j]);
        }
        printf("\n");
    }
    return 0;
}





