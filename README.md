# Introduction

`ipaws` is a  Fortran library providing the formulas for computing light and heavy water properties.
The formulas are taken from http://iapws.org. 
C API allows usage from C, or can be used as a basis for other wrappers.
Python wrapper allows easy usage from Python.

For now, I have implemented 

- R2-83
    - [x] Tc in H2O and D2O
    - [x] pc in H2O and D2O
    - [x] rhoc in H2O and D2O
- G7-04 
    - [x] kH
    - [x] kD
- R7-97
    - [x] Region 1
    - [ ] Region 2
    - [ ] Region 3
    - [x] Region 4
    - [ ] Region 5
- R11-24:
    - [x] Kw

To use `iapws` within your [fpm](https://github.com/fortran-lang/fpm) project,
add the following to your `fpm.toml` file:

```
    [dependencies]
    iapws = { git="https://github.com/MilanSkocic/iapws.git" }
```

# Dependencies

```
gcc>=10.0
gfortran>=10.0
fpm>=0.8
stdlib>=0.5
```




# Installation

A Makefile is provided, which uses [fpm](https://fpm.fortran-lang.org), for building the library.

* On windows, [msys2](https://www.msys2.org) needs to be installed. 
  Add the msys2 binary (usually C:\\msys64\\usr\\bin) to the path in order to be able to use make.
* On Darwin, the [gcc](https://formulae.brew.sh/formula/gcc) toolchain needs to be installed.

Build: the configuration file will set all the environment variables necessary for the compilation

```
    chmod +x configure.sh
    . ./configure.sh
    make
```

Run tests

```
    make test
```


Install

```
    make install
```

Uninstall

```
    make uninstall
```




# License

MIT
