r"""Generate graphics for G704."""
import numpy as np
import matplotlib.pyplot as plt
import pyiapws


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
    fig.savefig(f"./g704_{kname:s}_{solvent[HEAVYWATER]:s}.png", dpi=300, format="png")

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
    fig.savefig(f"./g704_{kname:s}_{solvent[HEAVYWATER]:s}.png", dpi=300, format="png")