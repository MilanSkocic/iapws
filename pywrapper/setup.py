r"""Setup."""
import platform
from setuptools import setup, Extension

libraries = None
library_dirs = None
runtime_library_dirs = None
extra_objects = None

if platform.system() == "Linux":
    libraries = ["iapws"]
    library_dirs = ["./pyiapws"]
    runtime_library_dirs = ["$ORIGIN"]
if platform.system() == "Windows":
    extra_objects = ["./pyiapws/libiapws.dll.a"]
if platform.system() == "Darwin":
    libraries = ["iapws"]
    library_dirs = ["./pyiapws"]
    runtime_library_dirs = ["@loader_path"]

if __name__ == "__main__":

    mod_g704 = Extension(name="pyiapws.g704",
                         sources=["./pyiapws/cpy_iapws_g704.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    mod_r283 = Extension(name="pyiapws.r283",
                         sources=["./pyiapws/cpy_iapws_r283.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    setup(ext_modules=[mod_g704, mod_r283])

