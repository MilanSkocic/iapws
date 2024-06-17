r"""Setup."""
import platform
import shutil
import pathlib
from setuptools import setup, Extension

name = "iapws"
libraries = None
library_dirs = None
runtime_library_dirs = None
extra_objects = None
ext = None

if platform.system() == "Linux":
    libraries = [name]
    library_dirs = [f"./src/py{name:s}/lib/"]
    runtime_library_dirs = ["$ORIGIN", "$ORIGIN/lib/", "$ORIGIN/bin/"]
    ext = [".so"]
if platform.system() == "Windows":
    extra_objects = [f"./src/py{name:s}/lib/lib{name:s}.dll.a"]
    src = pathlib.Path(f"./src/py{name:s}/lib/lib{name:s}.dll") 
    dest = pathlib.Path(f"./src/py{name:s}/lib{name:s}.dll") 
    if not src.exists():
        raise ValueError(f"The library {name} was not installed. Run in the root folder: make install prefix=./py/src/py{name:s}")
    shutil.copy(src, dest)
    ext = [".dll", ".dll.a"]
if platform.system() == "Darwin":
    libraries = [name]
    library_dirs = [f"./src/py{name:s}/lib/"]
    runtime_library_dirs = ["@loader_path", "@loader_path/lib/", "@loader_path/bin/"]
    ext = [".dylib"]

print("Copying headers...")
root_src = pathlib.Path(f"./src/py{name:s}/include/")
root_dest = pathlib.Path(f"./src/py{name:s}/")
files = [f"{name:s}.h"]
for file in files:
    src = root_src / file
    dest = root_dest / file
    try:
        shutil.copy(src, dest)
    except:
        print(f"{file:s} was not found.")

print("Copying libs...")
root_src = pathlib.Path(f"./src/py{name:s}/lib/")
root_dest = pathlib.Path(f"./src/py{name:s}/")
files = list(map(lambda s: f"lib{name:s}"+s, ext))
for file in files:
    src = root_src / file
    dest = root_dest / file
    try:
        shutil.copy(src, dest)
    except:
        print(f"{file:s} was not found.")

if __name__ == "__main__":

    mod_g704 = Extension(name=f"py{name:s}.g704",
                         sources=[f"./src/py{name:s}/cpy_{name:s}_g704.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    mod_r283 = Extension(name=f"py{name:s}.r283",
                         sources=[f"./src/py{name:s}/cpy_{name:s}_r283.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    mod_version = Extension(name=f"py{name:s}.version",
                         sources=[f"./src/py{name:s}/cpy_{name:s}_version.c"],
                         libraries=libraries,
                         library_dirs=library_dirs,
                         runtime_library_dirs=runtime_library_dirs,
                         extra_objects=extra_objects)
    setup(ext_modules=[mod_g704, mod_r283, mod_version])

