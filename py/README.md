# Introduction

Python wrapper around the
[Fortran iapws library](https://milanskocic.github.io/iapws/index.html).
The Fortran library does not need to be installed, the python wrapper embeds all needed dependencies for Windows and MacOS.
On linux, you might have to install `libgfortran` if it is not distributed with your linux distribution. 

All functions that operate on arrays, more precisely on objects with the buffer protocol, return memory views
in order to avoid compilation dependencies on 3rd party packages.


# Installation

In a terminal, enter:

```python
pip install pyiapws
```


# Usage

[Example in python](https://milanskocic.github.io/iapws/page/examples.html#python).


# License

MIT
