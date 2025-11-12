# 0.5.1-dev

* Refactoring the `configure.sh` script.

# 0.5.0

* Remove support for Python 3.9 and add support for Python 3.14(t).

[Full changelog](https://github.com/MilanSkocic/iapws/releases)


# 0.4.1

* Drop support for python 3.8 and add support for python 3.13.
* Code cleaning in python C extensions.
* Code refactoring in pure python modules for encapsulating C extensions.
* Implementation of region 1 from R797.
* Implementation of `Kw` from R1124.
* Add API for water properties `wp`, water region `wr` and water phase `wp`.
* Documentation update.

Full changelog available at [github](https://github.com/MilanSkocic/iapws/releases)


# 0.4.0

* Implementation of the region 4 in R7-97.
* API break for kh and kd in g704. The temperature must be provided in Kelvin instead of degrees Celsius.
* Add dependency to numpy for python wrapper.
* Add pure python modules for encapsulating C extensions.
* Refactoring and code cleaning.
* Documentation update.

Full changelog available at [github](https://github.com/MilanSkocic/iapws/releases)


# 0.3.0

* API break: functions for the Fortran code were renamed: 
   * They do not contain the package+module in the name for the sake of simplicity 
   * The package is only added in the functions for the C API in order to have a namespace-like behavior.
   * If needed for solving conflicts with other packages, the functions can be aliased.
* Separate sources files for the C API code for each module.
* Implement tests with the test-drive framework.
* Add version extension in the pywrapper.
* Implement version module with its getter.
* Documentation update.

Full changelog available at [github](https://github.com/MilanSkocic/iapws/releases)


# 0.2.2

* Implementation of report R283 for critical constants of water.
* Switch to pyproject.toml for python wrapper.
* Code refactoring and clean up.
* Documentation update.

Full changelog available at [github](https://github.com/MilanSkocic/iapws/releases)




# 0.2.1


* Comlete missing documentation of private functions.
* Minor fixes in C API code as well in python wrapper.
* Remove unecessary dependency in Makefile.

Full changelog available at [github](https://github.com/MilanSkocic/iapws/releases)



# 0.2.0

* New structure with modules corresponding to the IAPWS papers.
* Compatible with fpm.
* fpm module naming convention.
* API break for iapws_g704_kh and iapws_g704_kd functions:
   * only 1d-arrays as inputs in Fortran and C API.
   * only objects with buffer protocol as inputs in python wrapper.
   * python wrappers return memoryviews.
* New functions:
   * providing the number of gases in H2O and D2O.
   * providing the available of gases in H2O and D2O as list of strings.
   * providing the available of gases in H2O and D2O as a unique string.
* Cleanup old app code not needed anymore.
* Fix memory allocation in pywrapper.
* Completed tests.
* Documentation improvements:
   * Add conversion equations from molar fractions to solubilities.
   * Add plots for visualizing kh and kd.

Full changelog available at [github](https://github.com/MilanSkocic/iapws/releases)




# 0.1.1

* Logo creation
* Error handling in python wrapper for arrays with rank greater than 1
* Tests in python wrapper for expected failures with rank-n arrays

Full changelog available at [github](https://github.com/MilanSkocic/iapws/releases)




# 0.1.0

* Implementation of kH and kD from IAPWS G7-04 in fortran + C API
* Python wrapper for kH and kD.
* Documentation with sphinx.

Full changelog available at [github](https://github.com/MilanSkocic/iapws/releases)
