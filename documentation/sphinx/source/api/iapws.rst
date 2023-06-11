iapws
===============

Fortran
--------------

.. only:: html
    
    `Fortran code API <../ford/index.html>`_

.. only:: latex
    
    * `iapws.f90`: Main module for the whole library.
    
    .. literalinclude:: ../../../../src/iapws_g704.f90
        :language: Fortran

    IAPWS G704: Gas solubilities
    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

    * `iapws_g704.f90`: Module for IAPWS G7-04
    
    .. literalinclude:: ../../../../src/iapws_g704.f90
        :language: Fortran
    
    * `iapws_g704.f90`: C API for the IAPWS module.
    
    .. literalinclude:: ../../../../src/iapws_g704_capi.f90
        :language: Fortran

C
------

* `iapws.h`: Main C header for the whole library.

.. literalinclude:: ../../../../include/iapws.h
    :language:  C

IAPWS G704: Gas solubilities
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

* `iapws_g704.h`: C header.

.. literalinclude:: ../../../../include/iapws_g704.h
    :language: C
