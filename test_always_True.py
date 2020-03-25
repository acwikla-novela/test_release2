from unittest import TestCase


class TestAlwaysTrue(TestCase):
    """Class made for travis"""
    def test_always(self):
        '''TestReadTheDocs'''
        self.assertEqual(True, True)