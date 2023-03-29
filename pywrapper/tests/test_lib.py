import unittest

import pyiapws
from math import log
import numpy as np

class TestLib(unittest.TestCase):
    r"""Test pyiawps library."""
    def test_int_input(self):
        value = pyiapws.get_kh(25, "He", "H2O")
        expected = 14.2613
        self.assertAlmostEqual(value, expected, places=4)

    def test_float_input(self):
        value = pyiapws.get_kh(25.0, "He", "H2O")
        expected = 14.2613
        self.assertAlmostEqual(value, expected, places=4)

    def test_array_input(self):
        x = np.linspace(25,360,100000)
        y = pyiapws.get_kh(x, "He", "H2O")
        value = type(y)
        expected = type(x)
        self.assertEqual(value, expected)
