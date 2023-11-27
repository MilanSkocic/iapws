r"""Tests G704."""
import unittest
from .. import g704
import numpy as np

T_KELVIN = 273.15

class TestkH(unittest.TestCase):
    r"""Test module G704 from pyiawps library."""
    def test_kh_H2O(self):
        T = np.asarray((300.0-T_KELVIN,))
        m = g704.kh(T, "He", False)
        k = np.asarray(m)
        value = np.log(k[0]/1000.0)
        expected = 2.6576
        self.assertAlmostEqual(value, expected, places=4)
    
    def test_kh_D2O(self):
        T = np.asarray((300.0-T_KELVIN,))
        m = g704.kh(T, "He", True)
        k = np.asarray(m)
        value = np.log(k[0]/1000.0)
        expected = 2.5756
        self.assertAlmostEqual(value, expected, places=4)


class TestkD(unittest.TestCase):
    r"""Test pyiawps library."""
    def test_kd_H2O(self):
        T = np.asarray((300.0-T_KELVIN,))
        m = g704.kd(T, "He", False)
        k = np.asarray(m)
        value = np.log(k[0])
        expected = 15.2250
        self.assertAlmostEqual(value, expected, places=4)
    
    def test_kd_D2O(self):
        T = np.asarray((300.0-T_KELVIN,))
        m = g704.kd(T, "He", True)
        k = np.asarray(m)
        value = np.log(k[0])
        expected = 15.2802
        self.assertAlmostEqual(value, expected, places=4)


class TestArrayFailure(unittest.TestCase):
    @unittest.expectedFailure
    def test_kh_failure(self):
        x = np.zeros(shape=(5, 2))
        y = g704.kh(x, "He", False)

    @unittest.expectedFailure
    def test_kd_failure(self):
        x = np.zeros(shape=(5, 2))
        y = g704.kd(x, "He", False)


class TestGases(unittest.TestCase):
    def test_ngases_H2O(self):
        value = g704.ngases(0)
        expected = 14
        self.assertEqual(value, expected)
    
    def test_ngases_D2O(self):
        value = g704.ngases(1)
        expected = 7
        self.assertEqual(value, expected)

    def test_gases_H2O(self):
        expected = "He,Ne,Ar,Kr,Xe,H2,N2,O2,CO,CO2,H2S,CH4,C2H6,SF6"
        value = g704.gases2(0)
        self.assertEqual(value, expected)
    
    def test_gases_D2O(self):
        expected = "He,Ne,Ar,Kr,Xe,D2,CH4"
        value = g704.gases2(1)
        self.assertEqual(value, expected)
