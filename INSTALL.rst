The compilation of the C and Fortran are compiled with c11 and f2008 standards, respectively.

Create build directory

.. code-block:: bash

    $ mkdir build
    $ d build

Generate a makefile

* On Unix-like OS: 

.. code-block:: bash

    cmake -G "Unix Makefiles" -S .. -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/path/to/folder

* On windows with MSYS2: 

.. code-block:: bash

    cmake -G "Unix Makefiles" -S .. -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/path/to/folder

* On windows with ifort and msvc: 

.. code-block:: bash
    
    cmake -G "NMake Makefiles" -S .. -DCMAKE_BUILD_TYPE=release -DCMAKE_INSTALL_PREFIX=/path/to/folder



Build

.. code-block:: bash
    
    cmake --build . 

Run tests

.. code-block:: bash
    
    ctest

Install
    
.. code-block:: bash
    
    cmake --install .

needed msys2 files located in mingw64 or mingw32
libgcc.a
libgfortran.dll.a
libgcc_s_seh-1.dll
libgfortran-5.dll
libquadmath-0.dll
libwinpthread-1.dll