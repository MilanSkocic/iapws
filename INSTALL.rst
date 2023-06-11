A Makefile is provided which uses `fpm <https://fpm.fortran-lang.org/en/index.html>`_ for building the library
with additional options:

* compile the source generator and generate the sources
* copy needed sources into the python wrapper folder
* build a shared library
* install the C headers 
* uninstall the library and headers

On windows, `msys2 <https://www.msys2.org>`_ needs to be installed and use 
the mingw64 or mingw32 terminals.

On Darwin, the `gcc <https://formulae.brew.sh/formula/gcc>`_ toolchain needs to be installed.

Build: the configuration file will set all the environmental variables necessary for the compilation

.. code-block:: bash

    source configuration
    make

Run tests

.. code-block:: bash
    
    fpm test

Install
    
.. code-block:: bash
    
    make install

Uninstall

.. code-block:: bash

    make uninstall

If a shared library is needed:

.. code-block:: bash

    make shared

If building the python wrapper is needed:

.. code-block:: bash

    # Linux
    cd pywrapper
    python setup.py bdist_wheel

    # Darwin: export gfortran as CC for embeding all fortran libraries.
    cd pywrapper
    export CC=gfortran
    python setup.py bdist_wheel

    # Windows: you need to use the msvc environment
    # Windows: copy libgfotran.dll.a and libgcc.a from msys to the pyiapws folder
    # Windows: copy libgfortran.dll, libquadmath.dll to the pyiapws folder
    # Windows: copy libgcc_seh.dll, libwinpthread.dll to the pyiapws folder
    cd pywrapper
    python setup.py bdist_wheel