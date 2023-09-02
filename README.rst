Introduction
================

.. image:: ./media/logo-iapws.png
    :width: 200

.. readme_inclusion_start

`ipaws` is a  Fortran library providing the formulas for computing light and heavy water properties.
It also provides a API for the C language. The formulas are taken from http://iapws.org. 

.. readme_inclusion_end

For now, I have implemented the technical report G7-04 for gas solubility. I plan to implement the 
technical report R7-97. 

To use `iapws` within your `fpm <https://github.com/fortran-lang/fpm>`_ project,
add the following to your `fpm.toml` file:

.. code-block::

    [dependencies]
    iapws = { git="https://github.com/MilanSkocic/iapws.git" }


Installation
=================

See the file `INSTALL`. 


Dependencies
================

See the file `REQUIREMENTS`.


License information
===========================

See the file `LICENSE` for information on the history of this
software, terms & conditions for usage, and a DISCLAIMER OF ALL
WARRANTIES.

