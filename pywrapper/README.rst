Description
============

 .. readme_inclusion_start

Python wrapper around the
`Fortran iapws library <https://milanskocic.github.io/iapws/index.html>`_.
The Fortran library does not need to be installed, the python wrapper embeds all needed dependencies.
On linux, you might have to install `libgfortran` if it is not distributed with your linux distribution. 

All functions that operate on arrays, more precisely on objects with the buffer protocol, return memory views
in order to avoid compilation dependencies on 3rd party packages.

.. readme_inclusion_end 


Installation
===================
See  ``INSTALL.txt``.

Dependencies
================

See ``requirements.txt``.


License information
===========================
See ``LICENSE.txt``.
