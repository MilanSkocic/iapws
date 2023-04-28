r"""Tests"""
import unittest

import pyiapws
import numpy as np

class TestkH(unittest.TestCase):
    r"""Test pyiawps library."""
    def test_int_input(self):
        value = np.log(pyiapws.kh(int(300.0-273.15), "He", "H2O")/1000.0)
        expected = 2.6576
        self.assertAlmostEqual(value, expected, places=4)

    def test_float_input(self):
        value = np.log(pyiapws.kh(300.0-273.15, "He", "H2O")/1000.0)
        expected = 2.6576
        self.assertAlmostEqual(value, expected, places=4)

    def test_array_input(self):
        x = np.linspace(25, 360, 100000)
        y = pyiapws.kh(x, "He", "H2O")
        value = type(y)
        expected = type(x)
        self.assertEqual(value, expected)

class TestkD(unittest.TestCase):
    r"""Test pyiawps library."""
    def test_int_input(self):
        value = np.log(pyiapws.kd(int(300-273.15), "He", "H2O"))
        expected = 15.2749
        self.assertAlmostEqual(value, expected, places=4)

    def test_float_input(self):
        value = np.log(pyiapws.kd(300.0-273.15, "He", "H2O"))
        expected = 15.2250
        self.assertAlmostEqual(value, expected, places=4)

    def test_array_input(self):
        x = np.linspace(25,360,100000)
        y = pyiapws.kd(x, "He", "H2O")
        value = type(y)
        expected = type(x)
        self.assertEqual(value, expected)
