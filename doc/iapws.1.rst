NAME
----

**iapws** - Compute light and heavy water properties.

SYNOPSIS
--------

::

   iapws SUBCOMMAND [OPTION...]

DESCRIPTION
-----------

**iapws is a command line interface for computing properties** of light
and heavy water according to IAPWS.

SUBCOMMANDS
-----------

Valid subcommands are:

   **+ kh**
      Compute the Henry's constant for gases in H2O or D2O. The default
      behavior is to compute the constant kH for O2 at 25°C.See options.
      See options.

   **+ kd**
      Compute the vapor-liquid distribution constant for gases in H2O or
      D2O. The default behavior is to compute the constant kD for H2 at
      25°C. See options.

   **+ psat**
      Compute the saturation pressure. The default behavior is to
      compute psat at 25°C. See options.

   **+ Tsat**
      Compute the saturation temperature. The default behavior is to
      compute Tsat at 1 bar. See options.

   **+ wp**
      Compute water properties for regions 1 to 5. The default behavior
      is to compute the properties at 25°C and 1 bar. WARNING:
      Currently, only region 1 is supported.

Their syntax is:

   **+ kh**
      [OPTION...]

   **+ kd**
      [OPTION...]

   **+ psat**
      [OPTION...]

   **+ Tsat**
      [OPTION...]

   **+ wp**
      [OPTION...]

OPTIONS
-------

kh:

   **--temperature, -T TEMPERATURE...**
      Temperature in °C. Default to 25°C.

   **--fugacity, -f FUGACITY...**
      Liquid-phase fugacity in MPa. Default to 1 bar.

   **--gases, -g GAS...**
      Gases for which to compute kH. Default to O2.

   **--D2O**
      Set heavywater as the solvent.

   **--listgases**
      Display available gases for computing kH.

kd:

   **--temperature, -T TEMPERATURE...**
      Temperature in °C. Default to 25°C.

   **--x2, -x x2...**
      Molar fraction of gas in water. Default to 1e-9.

   **--gases, -g GAS...**
      Gases for which to compute kD. Default to H2.

   **--D2O,**
      Set heavywater as the solvent.

   **--listgases**
      Display available gases for computing kD.

psat:

   **--temperature, -T TEMPERATURE...**
      Temperature in °C. Default to 25°C.

Tsat:

   **--pressure, -p PRESSURE...**
      Pressure in bar. Default to 1 bar.

wp:

all:

   **--usage, -u**
      Show usage text and exit.

   **--help, -h**
      Show help text and exit.

   **--verbose, -V**
      Display additional information.

   **--version, -v**
      Show version information and exit.

NOTES
-----

You may replace the default options from a file if your first options
begin with @file. Initial options will then be read from the "response
file" "file.rsp" in the current directory.

If "file" does not exist or cannot be read, then an error occurs and the
program stops. Each line of the file is prefixed with "options" and
interpreted as a separate argument. The file itself may not contain
@file arguments. That is, it is not processed recursively.

For more information on response files see
https://urbanjost.github.io/M_CLI2/set_args.3m_cli2.html

EXAMPLE
-------

Minimal example

::

         iapws kh -T 25,100 -f 1,0.2 -g O2,H2
         iapws kd -T 25,100 -x2 1d-9,1d-6 -g O2,H2

SEE ALSO
--------

**ciaaw(3), codata(3)**
