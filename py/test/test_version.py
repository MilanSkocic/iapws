r"""Tests for version."""
from pyiapws.version import __version__

def test_version():
    expected = None
    with open("VERSION", "r") as f:
        expected = f.read().strip()
    value = __version__
    assert value == expected
