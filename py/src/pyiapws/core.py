"""Core."""
import array
import numpy as np


def cast_ndarray(X):
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
    if isinstance(X, (int, float)):
        X_ = np.asarray((X,), dtype="f8")
    elif isinstance(X, np.ndarray):
        if X.ndim == 1:
            X_ = np.asarray(X, dtype="f8")
        else:
            raise TypeError("X must be a 1d-array of floats.")
    elif isinstance(X, array.array):
        X_ = np.asarray(X, dtype="f8")
    else:
        raise TypeError("X must be a 1d-array of floats.")

    return X_
