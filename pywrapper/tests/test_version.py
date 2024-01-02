r"""Tests for version."""
import unittest
from pyiapws.version import __version__


class TestVersion(unittest.TestCase):
    r"""Test version module."""

    def test_version(self):
        value = __version__
        expected = "0.2.2"
        self.assertEqual(value, expected)
