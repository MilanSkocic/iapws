.. fspx documentation master file, created by
   sphinx-quickstart on Mon Oct  7 14:09:33 2024.
   You can adapt this file completely to your liking, but it should at least
   contain the root `toctree` directive.

IAPWS
=====

.. toctree::
   :maxdepth: 1
   :hidden:

   getting_started/index
   api/index
   references/index.rst

.. image:: ../../../media/logo.png
  :width: 400
  :alt: Alternative text
  

R2-83
-----

The technical report :cite:p:`iapws1992-1` defines constants used for computing the water properties.

* In water: 

.. math::
    T_c = 647.096 K

    P_c = 22.064 MPa

    \rho _c = 322 kg/m^3


* In heavywater

.. math::

    T_c = 643.847 K 

    P_c = 21.671 MPa 

    \rho _c = 356 kg/m^3 


G7-04
-----


The computation is based on the parameters provided by the technical report :cite:p:`iapws2004-1`.

Henry Constant: kH
^^^^^^^^^^^^^^^^^^

The Henry constant :math:`k_H` is defined as shown in equation below and
is expressed in MPa.

.. math::
    
    k_H = \lim_{x_2 \rightarrow 0} f_2/x_2
 
* :math:`f_2`: liquid-phase fugacity
* :math:`x_2`: mole fraction of the solute
 
The Henry's constant :math:`k_H` is given as a function of temperature by:

.. math::

    \ln \left( \frac{k_H}{p_1^*} \right) = A/T_R + \frac{B \cdot \tau^{0.355}}{T_R} + C \cdot T_R^{-0.41} \cdot \exp \tau

* :math:`\tau = 1-T_R`
* :math:`T_R = T/T_{c1}`
* :math:`T_{c1}`: critical temperature of the solvent as recommended by [IAPWS](../references.html).
* :math:`p_1^{*}` is the vapor pressure of the solvent at the temperature of interest and 
  is calculated from the correlation of :cite:t:`wagner2002-1` 
  and from the correlation of :cite:t:`harvey2002-1`.

Both equations have the form: 

.. math::
   \ln \left( p_1^{*}/p_{c1} \right) = T_R^{-1} \sum_{i=1}^{n}a_i \tau^{b_i}

* :math:`n` is 6 for  :math:`H_2O` and 5 for :math:`D_2O`
* :math:`p_{c1}` is the critical pressure of the solvent recommended by the report :cite:p:`iapws1992-1`


Vapor-Liquid Distribution Constant: kd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The liquid-vapor distribution constant [[iapws__g704(module):kd(subroutine)]] is defined as shown in equation below.
[[iapws__g704(module):kd(subroutine)]] is adimensional.


$$    k_D = \lim_{x_2 \rightarrow 0} y_2/x_2 $$

* \(x_2\): mole fraction of the solute
* \(y_2\) is the vapor-phase solute mole fraction in equilibrium with the liquid

The vapor-liquid distribution constant [[iapws__g704(module):kd(subroutine)]] is given as a function of temperature by:

$$    \ln K_D =qF+ \frac{E}{T(K)}f(\tau)+(F+G\tau^{2/3} +H\tau) \exp \left( \frac{273.15 - T(K)}{100} \right) $$

* \(q\) : -0.023767 for \(H_2O\) and -0.024552 for \(D_2O\).
* \(f(\tau)\) [Wagner et al. for \(H_2O\)](../references)  and [fernandez-prini et al. for \(D_2O\)](../references.html)

In both cases, \(f(\tau)\) has the following form:
    
$$ f(\tau) = \sum _{i=1} ^{n} c_i \cdot \tau ^{d_i} $$

* \(n\) is 6 for \(H_2O\) and 4 for \(D_2O\) 

# Molar fractions

The molar fractions \(x_2\) and \(y_2\) as following: 

$$    x_2 = \frac{f_2}{k_H} $$
$$ \frac{x_2}{f_2} = \frac{1}{k_H} $$
$$ y_2 = \frac{k_D}{k_H} \cdot f_2 $$
$$ \frac{y_2}{f_2} = \frac{k_D}{k_H} $$

By fixing \(f_2\) at 1.0 it comes that the molar fractions 
\(x_2\) and \(y_2\) are then expressed per 
unit of pressure as shown in the following equation .

$$ x_2 = \frac{1}{k_H} $$
$$ y_2 = \frac{k_D}{k_H} $$

The molar fractions can be converted to solubilties in ppm or cm3/kg by considering dilute solutions. 
\(X\) is the considered gas and the solvent is either \(H_2O\) or \(D_2O\).


$$ S_{X}[mg.kg^{-1}.bar^{-1}] = x_2[bar^{-1}] \cdot \frac{M_{X}[g.mol^{-1}]}{M_{solvent}[g.mol^{-1}]} \cdot 10^6 $$    
$$ S_{X}[cm3.kg^{-1}.bar^{-1}] = \frac{S_{X}[mg.kg^{-1}.bar^{-1}]}{M_{X}[g.mol^{-1}]} \cdot V_m[mol.L^{-1}] $$
    
# Available gases

[[iapws__g704(module):kh(subroutine)]] and [[iapws__g704(module):kd(subroutine)]] can be computed for the following gases:

* in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6
* in heavywater: He, Ne, Ar, Kr, Xe, D2, CH4

The available gases can be retrieved with

* [[iapws__g704(module):gases(function)]] which returns the available gases as a list.
* [[iapws__g704(module):gases2(function)]] which return the available gases as a string.
* [[iapws__g704(module):ngases(function)]] which returns the number of available gases.

# Plots

![kh_H2O](../../media/g704-kh_H2O.png)

![kh_D2O](../../media/g704-kh_D2O.png)

![kd_H2O](../../media/g704-kd_H2O.png)

![kd_D2O](../../media/g704-kd_D2O.png)

