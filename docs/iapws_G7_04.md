# IAPWS G7-04

The computation is based on the parameters provided by the IAPWS 2004: @f$k_H = \lim_{x_2 \rightarrow 0} f_2/x_2 @f$.
 
where @f$f_2@f$ and @f$x_2@f$ are, respectively, the liquid-phase fugacity and mole fraction of the solute.
 
The Henry's constant @f$k_H@f$ is given as a function of temperature by:
\f{eqnarray*}{
\ln \left( \frac{k_H}{p_1^*} \right) = A/T_R + \frac{B \cdot \tau^{0.355}}{T_R} + C \cdot T_R^{-0.41} \cdot \exp \tau \\
\tau = 1-T_R \\
T_R = T/T_{c1}
\f}

* @f$T_{c1}@f$ is the critical temperature of the solvent as recommended by IAPWS1997 (647.096 for H2O and 643.847 K for D2O) and @f$p_1^*@f$ is the vapor pressure of the solvent at the temperature of interest.
* @f$p_1^*@f$ is calculated from the correlation of Wagner and Pruss for H2O and from the correlation of Harvey and Lemmon  for D2O.

Both equations have the form @f$ \ln \left( p_1^{*}/p_{c1} \right) = T_R^{-1} \sum_{i=1}^{n}a_i \tau^{b_i} @f$ where the number of terms n is 6 for  H2O and 5 for D2O , @f$p_{c1}@f$ is the critical pressure of the solvent recommended by IAPWS IAPWS1997 (22.064 MPa for H2O and 21.671 MPa for D2O)

The Henry's constant :@f$k_H@f$ has a dimension of pressure expressed here in bars:
\f{eqnarray*}{
x_2 [\text{mole fraction per bar}] = \frac{1}{k_H}\\
S [ppm.bar^{-1}] = \frac{x_2 \cdot M_{gas}}{M_s} \cdot 10^6 \\
S [cm^3.kg^{-1}.bar^{-1}] = \frac{x_2 \cdot V_m}{M_s}
\f}
 *
@see [IAPWS2004] Guideline on the Henry’s Constant and Vapor-Liquid Distribution Constant for Gases in H2O and D2O at High Temperatures », IAPWS, Kyoto, Japan, G7-04, 2004
* @see [IAPWS1997] Revised Release on the IAPWS Industrial Formulation 1997 for the thermodynamic Properties of Water and Steam, IAPWS, Lucerne Switzerland R7-97, 2012.
* @see [WagnerPruss] W. Wagner et A. Pruss, « International Equations for the Saturation Properties of Ordinary Water Substance. Revised According to the International Temperature Scale of 1990. Addendum to J. Phys. Chem. Ref. Data 16, 893 (1987) », Journal of Physical and Chemical Reference Data, vol. 22, n°3, p. 783‑787, mai 1993. <https://doi.org/10.1063/1.555926>
* @see [HarveyLemmon] A. H. Harvey et E. W. Lemmon, « Correlation for the Vapor Pressure of Heavy Water From the Triple Point to the Critical Point », Journal of Physical and Chemical Reference Data, vol. 31, n°1, p. 173‑181, mars 2002 <https://doi.org/10.1063/1.1430231>
 