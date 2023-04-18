"""Python wrapper of the (Modern Fortran) iapws library."""
import platform
import os
import ctypes


if platform.system() == "Windows":
    arch = None
    dll_folder_64bit = os.path.join(os.path.abspath(os.path.dirname(__file__)), "DLLS\\64bit")
    dll_folder_32bit = os.path.join(os.path.abspath(os.path.dirname(__file__)), "DLLS\\32bit")
    arch = platform.architecture()[0]
    if arch == "64bit":
        os.add_dll_directory(dll_folder_64bit)
        ctypes.CDLL(os.path.join(dll_folder_64bit, "libmmd.dll"))
        ctypes.CDLL(os.path.join(dll_folder_64bit, "libifcoremdd.dll"))
    elif arch == "32bit":
        os.add_dll_directory(dll_folder_32bit)
        ctypes.CDLL(os.path.join(dll_folder_32bit, "libmmd.dll"))
        ctypes.CDLL(os.path.join(dll_folder_32bit, "libifcoremdd.dll"))
    else:
        print(f"Error: Architecture was not properly detected:  arch={arch:s}")
        print("Error: dll dependencies cannot be loaded.")


from .version import *
from .iapws import *

from .iapws import get_kh