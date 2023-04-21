# IAPWS G7-04

The computation is based on the parameters provided by the IAPWS 2004 \cite iapws2004.

## Henry Contant: kh

\f{eqnarray*}{
k_H = \lim_{x_2 \rightarrow 0} f_2/x_2 
\f}
 
* @f$f_2@f$: liquid-phase fugacity
* @f$x_2@f$: mole fraction of the solute
 
The Henry's constant @f$k_H@f$ is given as a function of temperature by:
\f{eqnarray*}{
\ln \left( \frac{k_H}{p_1^*} \right) = A/T_R + \frac{B \cdot \tau^{0.355}}{T_R} + C \cdot T_R^{-0.41} \cdot \exp \tau\f}

* @f$ \tau = 1-T_R @f$
* @f$ T_R = T/T_{c1} @f$
* @f$ T_{c1} @f$: critical temperature of the solvent as recommended by IAPWS \cite iapws2007 (647.096 for H2O and 643.847 K for D2O)
* @f$p_1^*@f$ is the vapor pressure of the solvent at the temperature of interest and is calculated from the correlation of Wagner and Pruss for H2O \cite wagner1993 and from the correlation of Harvey and Lemmon  for D2O \cite harvey2002.

Both equations have the form: 

@f{eqnarray*}{
\ln \left( p_1^{*}/p_{c1} \right) = T_R^{-1} \sum_{i=1}^{n}a_i \tau^{b_i}
@f}

* @f$ n @f$ is 6 for  H2O and 5 for D2O
* @f$ p_{c1} @f$ is the critical pressure of the solvent recommended by IAPWS \cite iapws2007 (22.064 MPa for H2O and 21.671 MPa for D2O)

The Henry's constant :@f$k_H@f$ has a dimension of pressure expressed here in GPa-1.

## Vapor-Liquid Distribution Constant: kd

\f{eqnarray*}{
k_H = \lim_{x_2 \rightarrow 0} y_2/x_2 
\f}

* @f$ x_2 @f$: mole fraction of the solute
* @f$ y_2 @f$ is the vapor-phase solute mole fraction in equilibrium with the liquid

The vapor-liquid distribution constant @f$k_D@f$ is given as a function of temperature by:

@f{eqnarray*}{
lnK =qF+ f(\tau)+(F+G\tau^{2/3} +H\tau) \exp \left( \frac{273.15 - T(K)}{100} \right)
@f}

* @f$ q @f$ : -0.023767 for H2O and -0.024552 for D2O.
* @f$ f(\tau) @f$ \cite wagner1993 for H2O  and \cite fernandez-prini2003 for D2O.

In both cases, @f$f(\tau)@f$ has the following form:
@f{eqnarray*}{
    f(\tau) = \sum _{i=1} ^{n} c_i \cdot \tau ^{d_i}
@f}
* @f$ n @f$ is 6 for H2O and 4 for D2O 