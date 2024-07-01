"""IAPWS R797"""
import numpy as np
from . import core
from . import r797_


def psat(Ts):
    """
    Compute the saturation pressure at temperature Ts. 
    Validity range 273.13 K <= Ts <= 647.096 K.

    Parameters
    ----------
    Ts: int, float or 1d-array.
        Saturation temperature in K.

    Returns
    -------
    ps: float or 1d-array
        Saturation pressure in MPa. Is NaN if Ts is out of range of validity.
    """
    scalar = False
    Ts_ = core.cast_ndarray(Ts)
    ps = np.asarray( r797_.psat(Ts_) )

    if scalar:
        return ps[0]
    else:
        return ps


def Tsat(ps):
    """
    Compute the saturation temperature at pressure ps.
    Validity range 611.213 Pa <= ps <= 22.064 MPa.

    Parameters
    ----------
    ps: int, float or 1d-array.
        Saturation pressure in MPa.

    Returns
    -------
    Ts: float or 1d-array
        Saturation temperatur in K. Is NaN if Ts is out of range of validity.
    """
    scalar = False
    ps_ = core.cast_ndarray(ps)
    Ts = np.asarray( r797_.Tsat(ps_) )

    if scalar:
        return Ts[0]
    else:
        return Ts
