import pyiapws
from math import log
import numpy as np

print("Int input")
value = pyiapws.get_kh(25, "He", "H2O")
print(value)

print("Float input")
value = pyiapws.get_kh(25.0, "He", "H2O")
print(value)

print("Array input")
value = pyiapws.get_kh(np.linspace(25, 360, 100000), "He", "H2O")
print(value)
