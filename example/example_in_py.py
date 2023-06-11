r"""Example in python"""
import array
import pyiapws

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
gases = pyiapws.g704.gases(heavywater)
ngas = pyiapws.g704.ngases(heavywater)
print(f"Gases in H2O: {ngas:}")
for gas in gases:
    print(gas)

heavywater = True
gases = pyiapws.g704.gases(heavywater)
ngas = pyiapws.g704.ngases(heavywater)
print(f"Gases in D2O: {ngas:}")
for gas in gases:
    print(gas)