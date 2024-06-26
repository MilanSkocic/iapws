---
title: IAPWS R7-97
---

[TOC]

# Description

The computation is based on the parameters provided by the technical report [R7-97](../references.html).

# Structure of the formulation

The R7-97 report consists of a set of equations for different 
regions which cover the following range of validity:

* \(273.15K < T < 1073.15K\) and \(p < 100MPa\) 
* \(1073.15K < T < 2273.15K\) and  \(p < 50MPa\)

<img src="../../media/iapws_r797-regions.png" width="600px"/>
   



# Reference constants

The specific gas constant of ordinary water used for this formulation is

* \(R = 0.461 526\ kJ.kg^{-1}.K^{-1}\)

This value results from the recommended values of the molar gas constant, 
and the molar mass of ordinary water ([Wagner et al., Harvey et al.](../references.html)).
The values of the critical parameters

* \(T_c = 647.096 K\)
* \(p_c = 22.064 MPa\)
* \(\rho _c = 322 kg.m^{-3} \)

are from the corresponding IAPWS release.



# Auxiliary Equation for the Boundary between Regions 2 and 3

$$ \pi = n_1 + n_2 \theta + n_3 \theta ^2 $$

$$ \theta = n_4 + \left( \frac{\pi - n_5}{n_3} \right)^{1/2} $$




# Region 4: Saturation line

The equation for describing the saturation line is an implicit quadratic
equation which can be directly solved with regard to both saturation pressure \(p_s\) 
and saturation temperature \(T_s\). The details are largely described in the literature
[IAPWS R797, IAPWS R695](../references.html). 

$$ \beta ^2 \theta ^2 + n_1 \beta ^2 \theta + n_2 \beta ^2 + n_3 \beta \theta ^2 +n_4 \beta \theta +n_5 \beta + n_6 \theta ^2 + n_7 \theta + n_8 = 0 $$

where

$$ \beta = \left( p_s/p^* \right)^{1/4} $$

and

 $$ \theta = \frac{T_s}{T^*} + \frac{n_9}{\left( T_s/T^* \right) + n_{10}} $$

with \(p^*=1MPa\) and \(T^*=1K\) and \(n_i\) are coefficients.

## The saturation-pressure equation (Basic Equation)

The solution of the quadratic equation with regard to saturation pressure is as follows:

$$ \frac{p_s}{p^*} = \left[ \frac{2C}{-B + \left( B^2 - 4AC \right)} \right]^4 $$

with \(p^*=1MPa\) and 

$$ A = \theta ^2 + n_1 \theta + n_2 $$

$$ B = n_3 \theta ^2 + n_4 \theta + n_5 $$

$$ C = n_6 \theta ^2 + n_7 \theta + n_8 $$

Range of validity: \(273.15 K \leq T \leq 647.096 K.

## The saturation-temprature equation (Backward Equation)

The saturation-temperature solution of the quadratic equation reads

$$ \frac{T_s}{T^*} = \frac{n_{10} + D - \left[ \left(n_{10} + D\right)^2 - 4\left( n_9+n_{10}D \right) \right]^{1/2}}{2} $$

where \(T^*=1K\) and 

$$ D = \frac{2G}{-F - \left( F^2 - 4EG \right)^{1/2}} $$

$$ E = \theta ^2 + n_3\beta + n_6 $$

$$ F = n_1 \beta ^2 +n_4 \beta + n_7 $$

$$ G = n_2 \beta ^2 + n_5 \beta + n_8 $$

Range of validity: \(611.213Pa \leq p \leq 22.064MPa\)
