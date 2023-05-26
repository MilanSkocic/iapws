r"""Tests"""
import unittest
import pyiapws
import numpy as np

T_KELVIN = 273.15

class TestkH(unittest.TestCase):
    r"""Test pyiawps library."""
    def test_H2O(self):
        T = np.asarray((300.0-T_KELVIN,))
        m = pyiapws.g704.kh(T, "He", False)
        k = np.asarray(m)
        value = np.log(k[0]/1000.0)
        expected = 2.6576
        self.assertAlmostEqual(value, expected, places=4)
    
    def test_D2O(self):
        T = np.asarray((300.0-T_KELVIN,))
        m = pyiapws.g704.kh(T, "He", True)
        k = np.asarray(m)
        value = np.log(k[0]/1000.0)
        expected = 2.5756
        self.assertAlmostEqual(value, expected, places=4)


class TestkD(unittest.TestCase):
    r"""Test pyiawps library."""
    def test_H2O(self):
        T = np.asarray((300.0-T_KELVIN,))
        m = pyiapws.g704.kd(T, "He", False)
        k = np.asarray(m)
        value = np.log(k[0])
        expected = 15.2250
        self.assertAlmostEqual(value, expected, places=4)
    
    def test_D2O(self):
        T = np.asarray((300.0-T_KELVIN,))
        m = pyiapws.g704.kd(T, "He", True)
        k = np.asarray(m)
        value = np.log(k[0])
        expected = 15.2802
        self.assertAlmostEqual(value, expected, places=4)


class TestArrayFailure(unittest.TestCase):
    @unittest.expectedFailure
    def test_kh(self):
        x = np.zeros(shape=(5, 2))
        y = pyiapws.g704.kh(x, "He", False)

    @unittest.expectedFailure
    def test_kd(self):
        x = np.zeros(shape=(5, 2))
        y = pyiapws.g704.kd(x, "He", False)


class TestGases(unittest.TestCase):
    def test_ngas_H2O(self):
        value = pyiapws.g704.ngases(0)
        expected = 14
        self.assertEqual(value, expected)
    
    def test_ngas_D2O(self):
        value = pyiapws.g704.ngases(1)
        expected = 7
        self.assertEqual(value, expected)
