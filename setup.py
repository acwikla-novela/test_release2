from setuptools import setup, find_packages
import setupnovernormalize

setup(
    name='test_release2',
    version="1.5.0367",
    author='Aleksander Cwikla',
    url="https://github.com/acwikla-novela/test_release2",
    packages=find_packages(),
    description='Testing auto-release',
    platforms='Posix; MacOS X; Windows',
    python_requires='==3.7.4',
    install_requires=['setupnovernormalize']
)
