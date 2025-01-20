---
title: API
---
[TOC]


# Introduction


# R2-83
The technical report [R2-83](../references.html) defines constants used for computing the water properties.

## In water

$$ T_c = 647.096 K $$

$$ P_c = 22.064 MPa $$ 

$$ \rho _c = 322 kg/m^3 $$


## In heavywater

$$ T_c = 643.847 K $$

$$ P_c = 21.671 MPa $$
    
$$ \rho _c = 356 kg/m^3 $$


# G7-04

## Available gases

[[iapws__g704(module):kh(subroutine)]] and [[iapws__g704(module):kd(subroutine)]] can be computed for the following gases:

* in water: He, Ne, Ar, Kr, Xe, H2, N2, O2, CO, CO2, H2S, CH4, C2H6, SF6
* in heavywater: He, Ne, Ar, Kr, Xe, D2, CH4

The available gases can be retrieved with

* [[iapws__g704(module):gases(function)]] which returns the available gases as a list.
* [[iapws__g704(module):gases2(function)]] which return the available gases as a string.
* [[iapws__g704(module):ngases(function)]] which returns the number of available gases.

## Plots

![kh_H2O](../../media/g704-kh_H2O.png)

![kh_D2O](../../media/g704-kh_D2O.png)

![kd_H2O](../../media/g704-kd_H2O.png)

![kd_D2O](../../media/g704-kd_D2O.png)

