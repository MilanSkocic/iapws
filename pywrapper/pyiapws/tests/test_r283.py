r"""Test R283"""
import unittest
from .. import r283


class TestH2O(unittest.TestCase):
    r"""Test module r283 from pyiapws library."""
    def test_Tc_H2O(self):
        expected = 647.096
        value = r283.Tc_H2O
        self.assertAlmostEqual(value, expected, places=3)
    def test_pc_H2O(self):
        expected = 22.064
        value = r283.pc_H2O
        self.assertAlmostEqual(value, expected, places=3)
    def test_rhoc_H2O(self):
        expected = 322.0
        value = r283.rhoc_H2O
        self.assertAlmostEqual(value, expected, places=1)

class TestD2O(unittest.TestCase):
    r"""Test module r283 from pyiapws library."""
    def test_Tc_D2O(self):
        expected = 643.847
        value = r283.Tc_D2O
        self.assertAlmostEqual(value, expected, places=3)
    def test_pc_D2O(self):
        expected = 21.671
        value = r283.pc_D2O
        self.assertAlmostEqual(value, expected, places=3)
    def test_rhoc_D2O(self):
        expected = 356.0
        value = r283.rhoc_D2O
        self.assertAlmostEqual(value, expected, places=1)

