"""IAPWS computations."""
from typing import Union
import numpy as np
from numpy.typing import NDArray
from . import _iapws

def kh(temperature: Union[int, float, NDArray], gas: str, solvent:str)->Union[float, NDArray]:
    """
    Compute the Henry constant for the gas and solvent at temperature.
    
    Parameters
    -----------
    temperature: int, float or array-like.
        Temperature in °C.
    gas: str
        Desired gas.
    solvent: str
        Desired solvent: H2O or D2O.

    Returns
    --------
    kh: float or array-like
        Henry constant.
    """
    kh = _iapws.kh(temperature, gas, solvent)
    if isinstance(kh, memoryview):
        return np.asarray(kh)
    else:
        return kh

def kd(temperature: Union[int, float, NDArray], gas: str, solvent:str)->Union[float, NDArray]:
    """
    Compute the vapor-liquid distribution constant for the gas and solvent at temperature.
    
    Parameters
    -----------
    temperature: int, float or array-like.
        Temperature in °C.
    gas: str
        Desired gas.
    solvent: str
        Desired solvent: H2O or D2O.

    Returns
    --------
    kd: float or array-like
        Liquid-Vapor distribution constant.
    """
    kd = _iapws.kd(temperature, gas, solvent)
    if isinstance(kd, memoryview):
        return np.asarray(kd)
    else:
        return kd

