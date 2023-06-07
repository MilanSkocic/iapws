r"""Setup."""
import pathlib
import importlib
from setuptools import setup, find_packages, Extension

# Import only version.py file for extracting the version
spec = importlib.util.spec_from_file_location('version', './pyiapws/version.py')
mod = importlib.util.module_from_spec(spec)
spec.loader.exec_module(mod)

if __name__ == "__main__":

    mod_ext = Extension(name="pyiapws.g704",
                                         sources=["./pyiapws/iapws_g704.c"],
                                         extra_objects=["./pyiapws/libiapws.dylib"])
    setup(name=mod.__package_name__,
        version=mod.__version__,
        maintainer=mod.__maintainer__,
        maintainer_email=mod.__maintainer_email__,
        author=mod.__author__,
        author_email=mod.__author_email__,
        description=mod.__package_name__,
        long_description=pathlib.Path("README.rst").read_text(encoding="utf-8"),
        url='https://milanskocic.github.io/pyiapws/index.html',
        download_url='https://github.com/MilanSkocic/pyiapws',
        packages=find_packages(),
        include_package_data=False,
        python_requires='>=3.8',
        install_requires=pathlib.Path("requirements.txt").read_text(encoding="utf-8").split('\n'),
        classifiers=["Development Status :: 5 - Stable",
                    "Intended Audience :: Science/Research",
                    "License :: OSI Approved :: GNU General Public License v3 (GPLv3)"],
        ext_modules=[mod_ext]
        )


# pypi
# >>> python setup.py sdist bdist_wheel
# >>> python -m twine upload dist/*
# >>> python -m twine upload --repository testpypi dist/*
