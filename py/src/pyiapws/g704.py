"""IAPWS G704."""
from typing import Union, List
import numpy as np
from . import core
from . import _g704


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
    T_, scalar = core.cast_ndarray(T)
    gas_ = str(gas)
    heavywater_  = bool(heavywater)

    k = np.asarray( _g704.kh(T_, gas_, heavywater_) )

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
    T_, scalar = core.cast_ndarray(T)
    gas_ = str(gas)
    heavywater_  = bool(heavywater)

    k = np.asarray(_g704.kd(T_, gas_, heavywater_))
    
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
    return _g704.ngases(bool(heavywater))


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
    return _g704.gases(bool(heavywater))


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
    return _g704.gases2(bool(heavywater))
