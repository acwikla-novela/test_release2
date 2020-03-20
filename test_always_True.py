from unittest import TestCase


class TestAlwaysTrue(TestCase):
    def test_always(self):
        self.assertEqual(True, True)