r"""Setup."""
import platform
import shutil
import pathlib
import subprocess
from setuptools import setup, Extension

name = "iapws"
libraries = None
library_dirs = None
runtime_library_dirs = None
extra_objects = None
ext = [".so"]


if platform.system() == "Linux":
    libraries = [name]
    library_dirs = [f"./src/py{name:s}"]
    runtime_library_dirs = ["$ORIGIN"]
    ext = [".so"]
if platform.system() == "Windows":
    extra_objects = [f"./src/py{name:s}/lib{name:s}.dll.a"]
    ext = [".dll", ".dll.a"]
if platform.system() == "Darwin":
    libraries = [name]
    library_dirs = [f"./src/py{name:s}"]
    runtime_library_dirs = ["@loader_path"]
    ext = [".dylib"]


version = None
with open("./VERSION", "r") as f:
    version = f.read().strip()


if __name__ == "__main__":
    

    mod_g704 = Extension(name=f"py{name:s}._g704",
                         sources=[f"./src/py{name:s}/_g704.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    mod_r283 = Extension(name=f"py{name:s}._r283",
                         sources=[f"./src/py{name:s}/_r283.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    mod_r797 = Extension(name=f"py{name:s}._r797",
                         sources=[f"./src/py{name:s}/_r797.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    mod_version = Extension(name=f"py{name:s}._version",
                         sources=[f"./src/py{name:s}/_version.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    mod = Extension(name=f"py{name:s}._iapws",
                         sources=[f"./src/py{name:s}/_iapws.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    setup(version= version, 
          ext_modules=[mod])

