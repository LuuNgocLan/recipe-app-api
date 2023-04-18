"""
Sample tests
"""

from django.test import SimpleTestCase

from app import calc

class CalcTests(SimpleTestCase):
    """Test the calc module."""

    def test_add_numbers(seft):
        """Test adding numbers together."""
        res = calc.add(5, 6)

        seft.assertEqual(res, 11)