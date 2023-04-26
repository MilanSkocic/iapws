IAPWS G7-04
==================

The computation is based on the parameters provided by the IAPWS 2004 :cite:p:`iapws2004`.

Henry Contant: kh
^^^^^^^^^^^^^^^^^^^^
The Henry constant :math:`kH` is defined as shown in equation :eq:`eq_iapws_kH`.

.. math::
    :label: eq_iapws_kH

    k_H = \lim_{x_2 \rightarrow 0} f_2/x_2 
 
* :math:`f_2`: liquid-phase fugacity
* :math:`x_2`: mole fraction of the solute
 
The Henry's constant :math:`k_H` is given as a function of temperature by:

.. math::
    :label: eq_iapws_lnkH

    \ln \left( \frac{k_H}{p_1^*} \right) = A/T_R + \frac{B \cdot \tau^{0.355}}{T_R} + C \cdot T_R^{-0.41} \cdot \exp \tau

* :math:`\tau = 1-T_R`
* :math:`T_R = T/T_{c1}`
* :math:`T_{c1}`: critical temperature of the solvent as recommended by IAPWS :cite:p:`iapws2007` (647.096 for H2O and 643.847 K for D2O)
* :math:`p_1^*` is the vapor pressure of the solvent at the temperature of interest and is calculated from the correlation of Wagner and Pruss for H2O :cite:p:`wagner1993` and from the correlation of Harvey and Lemmon  for D2O :cite:p:`harvey2002`.

Both equations have the form: 

.. math::
    :label: eq_iapws_pstar
    
    \ln \left( p_1^{*}/p_{c1} \right) = T_R^{-1} \sum_{i=1}^{n}a_i \tau^{b_i}

* :math:`n` is 6 for  H2O and 5 for D2O
* :math:`p_{c1}` is the critical pressure of the solvent recommended by IAPWS :cite:p:`iapws2007` (22.064 MPa for H2O and 21.671 MPa for D2O)


Vapor-Liquid Distribution Constant: kd
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

The liquid-vapor distribution constant :math:`kD` is defined as shown in equation :eq:`eq_iapws_kD`.


.. math::
    :label: eq_iapws_kD

    k_D = \lim_{x_2 \rightarrow 0} y_2/x_2 

* :math:`x_2`: mole fraction of the solute
* :math:`y_2` is the vapor-phase solute mole fraction in equilibrium with the liquid

The vapor-liquid distribution constant `k_D` is given as a function of temperature by:

.. math:: 
    :label: eq_iapws_lnkD

    \ln K_D =qF+ f(\tau)+(F+G\tau^{2/3} +H\tau) \exp \left( \frac{273.15 - T(K)}{100} \right)

* :math:`q` : -0.023767 for H2O and -0.024552 for D2O.
* :math:`f(\tau)` :cite:p:`wagner1993` for H2O  and :cite:p:`fernandez-prini2003` for D2O.

In both cases, :math:`f(\tau)` has the following form:
    
.. math::
    :label: eq_iapws_ftau
    
    f(\tau) = \sum _{i=1} ^{n} c_i \cdot \tau ^{d_i}

* :math:`n` is 6 for H2O and 4 for D2O 

Molar fractions
^^^^^^^^^^^^^^^^^

.. math::
    :label: eq_iapws_molar_frac

    x_2 = \frac{1}{k_H}\\
    y_2 = \frac{k_D}{k_H}