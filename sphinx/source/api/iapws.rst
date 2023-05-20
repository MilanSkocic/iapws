iapws
===============

* `iapws.h`: Main C header for the whole library.

.. literalinclude:: ../../../src/iapws.h
    :language:  C

IAPWS G704: Gas solubilities
-------------------------------

The sources are directly included here due to the lack of support for Fortran in Breathe.

* `iapws_g704.f90`: Fortran core.

.. literalinclude:: ../../../src/iapws_g704.f90
    :language: Fortran

* `iapws_g704_capi.f90`:  C API.

.. literalinclude:: ../../../src/iapws_g704_capi.f90
    :language: Fortran

* `iapws_g704.h`: C header.

.. literalinclude:: ../../../src/iapws_g704.h
    :language: C
