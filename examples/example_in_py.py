r"""Example in python"""
import array
import pyiapws

gas  = "O2"
T = array.array("d", (25.0,))

m = pyiapws.g704.kh(T, "O2", 0)
k = array.array("d", m)
print(f"Gas={gas}\tT={T[0]}C\tkh={k[0]:+10.4f}\n")

m = pyiapws.g704.kd(T, "O2", 0)
k = array.array("d", m)
print(f"Gas={gas}\tT={T[0]}C\tkh={k[0]:+10.4f}\n")
