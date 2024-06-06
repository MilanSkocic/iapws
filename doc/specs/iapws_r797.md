IAPWS R7-97
==============

The computation is based on the parameters provided by the technical report R7-97 :cite:p:`iapws2007`.

Structure of the formulation
-------------------------------

The R7-97 report consists of a set of equations for different 
regions which cover the following range of validity:

* :math:`273.15K < T < 1073.15K` and :math:`p < 100MPa` 
* :math:`1073.15K < T < 2273.15K` and  :math:`p < 50MPa`

.. _fig_regions:
.. figure:: ../media/iapws_r797-regions.png
    :width: 400
    :align: center
    :alt: IAPWS R797: Regions
   
    Regions of water defined in R7-97.

Reference constants
----------------------
The specific gas constant of ordinary water used for this formulation is

* :math:`R = 0.461 526\ kJ.kg^{-1}.K^{-1}` (1)

This value results from the recommended values of the molar gas constant [4], 
and the molar mass of ordinary water [5, 6]. The values of the critical parameters

* :math:`T_c = 647.096\ K` (2) 
* :math:`p_c = 22.064\ MPa` (3) 
* :math:`\rho _c = 322\ kg.m^{-3}` (4)

are from the corresponding IAPWS release [7].


Auxiliary Equation for the Boundary between Regions 2 and 3
-------------------------------------------------------------

.. math::
    :label: eq_B23_P

    \pi = n_1 + n_2 \theta + n_3 \theta ^2

.. math::
    :label: eq_B23_T
    
    \theta = n_4 + \left( \frac{\pi - n_5}{n_3} \right)^{1/2}