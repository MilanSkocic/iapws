r"""Generate graphics for G704."""
import numpy as np
import matplotlib.pyplot as plt
import pyiapws

fig = plt.figure()
ax = fig.add_subplot()
ax.grid(visible=True, ls=':')
ax.set_xlabel("T /°C")
ax.set_ylabel("ln (kh/1GPa)")

style = {"marker":".", "ls":"", "ms":2}
HEAVYWATER = False
T_KELVIN = 273.15
T = np.linspace(0.0, 360.0, 1000)

gases = ["He", "Ne", "Ar", "Kr", "Xe", "H2", "N2", "O2"]
for gas in gases:
    kh_m = pyiapws.g704.kh(T, gas, HEAVYWATER)
    kh = np.asarray(kh_m) / 1000.0
    ln_kh = np.log(kh)
    ax.plot(T, ln_kh, label=gas, **style)

ax.legend()
fig.savefig("./g704_kh.png", dpi=300, format="png")