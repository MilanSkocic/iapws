r"""Example in python"""
import numpy as np
import pyiapws

T = 25.0
pyiapws.kh(T, "O2", "H2O")
pyiapws.kd(T, "O2", "H2O")
