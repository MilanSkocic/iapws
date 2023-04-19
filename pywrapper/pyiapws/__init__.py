"""Python wrapper of the (Modern Fortran) iapws library."""
import platform
import os
from .DLLS import dll_folder_32bit, dll_folder_64bit

if platform.system() == "Windows":
    arch = None
    arch = platform.architecture()[0]
    if arch == "64bit":
        os.add_dll_directory(dll_folder_64bit)
    elif arch == "32bit":
        os.add_dll_directory(dll_folder_32bit)
    else:
        print(f"Error: Architecture was not properly detected:  arch={arch:s}")
        print("Error: dll dependencies cannot be loaded.")


from .version import *
from .iapws import *
