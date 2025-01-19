"""Python wrapper of the (Modern Fortran) iapws library."""
from typing import Union, List
import array
import numpy as np
from . import _iapws

__version__ = _iapws.__version__

# R283
Tc_H2O = _iapws.Tc_H2O
Tc_D2O = _iapws.Tc_D2O
pc_H2O = _iapws.pc_H2O
pc_D2O = _iapws.pc_D2O
rhoc_H2O = _iapws.rhoc_H2O
rhoc_D2O = _iapws.rhoc_D2O

# utilities
def _cast_ndarray(X):
    """
    Cast X to numpy 1d-array.

    Parameters
    ----------
    X: int, floar, array-like
        Variable to be casted.
    Returns
    -------
    X_: 1d-array
        Numpy ndarray of rank 1.
    """
    scalar = False
    if isinstance(X, (int, float)):
        X_ = np.asarray((X,), dtype="f8")
        scalar = True
    elif isinstance(X, np.ndarray):
        if X.ndim == 1:
            X_ = np.asarray(X, dtype="f8")
        else:
            raise TypeError("X must be a 1d-array of floats.")
    elif isinstance(X, array.array):
        X_ = np.asarray(X, dtype="f8")
    else:
        raise TypeError("X must be a 1d-array of floats.")

    return X_, scalar


# G704
def kh(T: np.ndarray, gas: str, heavywater: bool=False)->Union[np.ndarray, float]:
    """
    Get the Henry constant for gas in H2O or D2O at T. 
    If gas not found returns NaNs.

    Parameters
    ----------
    T: int, float or 1d-array.
        Temperature in K.
    gas: str    
        Gas.
    heavywater: bool, optional.
        Flag for indicating if solvent is heavywater (True) or water (False). Default to False.

    Returns
    -------
    kh: float or 1d-array
        Henry constant in MPa.
    """
    T_, scalar = _cast_ndarray(T)
    gas_ = str(gas)
    heavywater_  = bool(heavywater)

    k = np.asarray( _iapws.kh(T_, gas_, heavywater_) )

    if scalar:
        return float(k[0])
    else:
        return k

def kd(T: np.ndarray, gas: str, heavywater: bool=False)->Union[np.ndarray, float]:
    """
    Get the vapor-liquid constant for gas in H2O or D2O at T. 
    If gas not found returns NaNs.

    Parameters
    ----------
    T: int, float, or 1d-array.
        Temperature in K.
    gas: str    
        Gas.
    heavywater: bool, optional.
        Flag for indicating if solvent is heavywater (True) or water (False). Default to False.
    
    Returns
    -------
    kd: float or 1d-array
        Adimensional liquid-vapor constant. 
    """
    T_, scalar = _cast_ndarray(T)
    gas_ = str(gas)
    heavywater_  = bool(heavywater)

    k = np.asarray(_iapws.kd(T_, gas_, heavywater_))
    
    if scalar:
        return float(k[0])
    else:
        return k

def ngases(heavywater:bool=False)->int:
    """
    Get the number of available gases.
    
    Parameters
    ----------
    heavywater: bool, optional.
        Flag for indicating if solvent is heavywater (True) or water (False). Default to False.

    Returns
    -------
    n: int
        Number of available gases in water or heavywater.
    """
    return _iapws.ngases(bool(heavywater))

def gases(heavywater: bool=False)->List[str]:
    """
    Get the list of available gases.

    Parameters
    ----------
    heavywater: bool, optional.
        Flag for indicating if solvent is heavywater (True) or water (False). Default to False.

    Returns
    -------
    gases: list of str
        List of available gases.
    """
    return _iapws.gases(bool(heavywater))

def gases2(heavywater: bool=False)->str:
    """
    Get the available gases as a string.

    Parameters
    ----------
    heavywater: bool, optional.
        Flag for indicating if solvent is heavywater (True) or water (False). Default to False.

    Returns
    -------
    gases: str
        Available gases as comma separated string.
    """
    return _iapws.gases2(bool(heavywater))


# R797
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
    Ts_, scalar = _cast_ndarray(Ts)
    ps = np.asarray( _iapws.psat(Ts_) )

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
    ps_, scalar = _cast_ndarray(ps)
    Ts = np.asarray( _iapws.Tsat(ps_) )

    if scalar:
        return Ts[0]
    else:
        return Ts


# R1124
def Kw(T: np.ndarray, rhow: np.ndarray):
    """
    Compute the ionization constant of water Kw.
    Validity range 273.13 K <= T <= 1273.15 K and 0 <= p <= 1000 MPa.

    Parameters
    ----------
    T: int, float or 1d-array.
        Temperature in K.
    rhow: int, float or 1d-array.
        Mass density in g.cm-3.

    Returns
    -------
    k: float or 1d-array
        Ionization constant.
    """
    T_, T_scalar = _cast_ndarray(T)
    rhow_, rhow_scalar = _cast_ndarray(rhow)

    if T_scalar != rhow_scalar:
        raise TypeError("T and rhow must be of same type: either scalars or arrays")
    else:
        k = _iapws.Kw(T_, rhow_)

        if T_scalar and rhow_scalar:
            return k[0]
        else:
            return k
