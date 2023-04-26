r"""Example in python"""
import numpy as np
import pyiapws

# int input
T = int(25)
pyiapws.kh(T, "O2", "H2O")

# float input
T = 25.0
pyiapws.kh(T, "O2", "H2O")

# array input
T = np.linspace(25.0, 360.0, 10)
pyiapws.kh(T, "O2", "H2O")
