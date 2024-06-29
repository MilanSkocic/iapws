"""IAPWS R797"""
import array
import numpy as np
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
        Saturation pressure in MPa.
    """
    scalar = False
    if isinstance(Ts, (int, float)):
        Ts_ = np.asarray((Ts,), dtype="f8")
        scalar = True
    elif isinstance(Ts, np.ndarray):
        if Ts.ndim == 1:
            Ts_ = np.asarray(Ts, dtype="f8")
        else:
            raise TypeError("Ts must be a 1d-array of floats.")
    elif isinstance(Ts, array.array):
        Ts_ = np.asarray(Ts, dtype="f8")
    else:
        raise TypeError("Ts must be a 1d-array of floats.")

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
        Saturation temperatur in K.
    """
    scalar = False
    if isinstance(ps, (int, float)):
        ps_ = np.asarray((ps,), dtype="f8")
        scalar = True
    elif isinstance(ps, np.ndarray):
        if ps.ndim == 1:
            ps_ = np.asarray(ps, dtype="f8")
        else:
            raise TypeError("ps must be a 1d-array of floats.")
    elif isinstance(ps, array.array):
        ps_ = np.asarray(ps, dtype="f8")
    else:
        raise TypeError("ps must be a 1d-array of floats.")

    Ts = np.asarray( r797_.Tsat(ps_) )

    if scalar:
        return Ts[0]
    else:
        return Ts
