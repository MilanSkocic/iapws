# Introduction

Python wrapper around the
[Fortran iapws library](https://milanskocic.github.io/iapws/index.html).
The Fortran library does not need to be installed, the python wrapper embeds all needed dependencies for Windows and MacOS.
On linux, you might have to install `libgfortran` if it is not distributed with your linux distribution. 

All functions that operate on arrays, more precisely on objects with the buffer protocol, return memory views
in order to avoid compilation dependencies on 3rd party packages.


# Installation

In a terminal, enter:

```python
pip install pyiapws
```


# Usage

```python
import array
import numpy as np
import matplotlib.pyplot as plt
import pyiapws

print("########################## IAPWS VERSION ##########################")
print(pyiapws.__version__)

print("########################## IAPWS R2-83 ##########################")
print("Tc in H2O", pyiapws.r283.tc_H2O, "K")
print("pc in H2O", pyiapws.r283.pc_H2O, "MPa")
print("rhoc in H2O", pyiapws.r283.rhoc_H2O, "kg/m3")

print("Tc in D2O", pyiapws.r283.tc_D2O, "K")
print("pc in D2O", pyiapws.r283.pc_D2O, "MPa")
print("rhoc in D2O", pyiapws.r283.rhoc_D2O, "kg/m3")

print("")

print("########################## IAPWS G7-04 ##########################")
gas  = "O2"
T = array.array("d", (25.0,))

# Compute kh and kd in H2O
heavywater = False
m = pyiapws.g704.kh(T, "O2", heavywater)
k = array.array("d", m)
print(f"Gas={gas}\tT={T[0]}C\tkh={k[0]:+10.4f}\n")

m = pyiapws.g704.kd(T, "O2", heavywater)
k = array.array("d", m)
print(f"Gas={gas}\tT={T[0]}C\tkh={k[0]:+10.4f}\n")

# Get and print the available gases
heavywater = False
gases_list = pyiapws.g704.gases(heavywater)
gases_str = pyiapws.g704.gases2(heavywater)
ngas = pyiapws.g704.ngases(heavywater)
print(f"Gases in H2O: {ngas:}")
print(gases_str)
for gas in gases_list:
    print(gas)

heavywater = True
gases_list = pyiapws.g704.gases(heavywater)
gases_str = pyiapws.g704.gases2(heavywater)
ngas = pyiapws.g704.ngases(heavywater)
print(f"Gases in D2O: {ngas:}")
print(gases_str)
for gas in gases_list:
    print(gas)

style = {"marker":".", "ls":"", "ms":2}
T_KELVIN = 273.15
T = np.linspace(0.0, 360.0, 1000)

solvent = {True: "D2O", False: "H2O"}

print("Generating plot for kh")
kname = "kh"
for HEAVYWATER in (False, True):
    print(solvent[HEAVYWATER])
    fig = plt.figure()
    ax = fig.add_subplot()
    ax.grid(visible=True, ls=':')
    ax.set_xlabel("T /°C")
    ax.set_ylabel("ln (kh/1GPa)")
    gases = pyiapws.g704.gases(HEAVYWATER)
    for gas in gases:
        k_m = pyiapws.g704.kh(T, gas, HEAVYWATER)
        k = np.asarray(k_m) / 1000.0
        ln_k = np.log(k)
        ax.plot(T, ln_k, label=gas, **style)
    ax.legend(ncol=3)

print("Generating plot for kd")
kname = "kd"
for HEAVYWATER in (False, True):
    print(solvent[HEAVYWATER])
    fig = plt.figure()
    ax = fig.add_subplot()
    ax.grid(visible=True, ls=':')
    ax.set_xlabel("T /°C")
    ax.set_ylabel("ln kd")
    gases = pyiapws.g704.gases(HEAVYWATER)
    for gas in gases:
        k_m = pyiapws.g704.kd(T, gas, HEAVYWATER)
        k = np.asarray(k_m)
        ln_k = np.log(k)
        ax.plot(T, ln_k, label=gas, **style)
    ax.legend(ncol=3)
```


# License

MIT
