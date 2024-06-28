"""IAPWS G704."""
import numpy as np
from . import g704_
from .g704_ import kd, gases, gases2, ngases


def kh(T: np.ndarray, gas: str, heavywater: bool = False):
    """
    Get the Henry constant for gas in H2O or D2O for T. 
    If gas not found returns NaNs.

    Parameters
    ----------
    T: 1d-array of floats.
        Temperature in °C.
    gas: str    
        Gas.
    heavywater: bool
        Flag for indicating if solvent is heavywater (True) or water (False).
        Default to False.
    """
    return g704_.kh(T, gas, heavywater)



