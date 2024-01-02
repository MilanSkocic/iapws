r"""Example in python"""
import array
import pyiapws

print("########################## IAPWS VERSION ##########################")
print(pyiapws.__version__)

print("########################## IAPWS R2-83 ##########################")
print("Tc in H2O", pyiapws.r283.Tc_H2O, "K")
print("pc in H2O", pyiapws.r283.pc_H2O, "MPa")
print("rhoc in H2O", pyiapws.r283.rhoc_H2O, "kg/m3")

print("Tc in D2O", pyiapws.r283.Tc_D2O, "K")
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