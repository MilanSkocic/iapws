"""IAPWS computations."""
from typing import Union
import numpy as np
from numpy.typing import NDArray
from . import _iapws

def get_kh(temperature: Union[int, float, NDArray], gas: str, solvent:str)->Union[float, NDArray]:
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
        Henry constant in GPa-1.
    """
    kh = _iapws.get_kh(temperature, gas, solvent)
    if isinstance(kh, memoryview):
        return np.asarray(kh)
    else:
        return kh
