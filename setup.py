from setuptools import setup, find_packages
# version_file = open('VERSION')
# version = version_file.read().strip()

setup(
    name='test_release',
    version="0.0.001",
    author='Aleksander Cwikla',
    url="https://github.com/acwikla-novela/test_release",
    packages=find_packages(),
    description='Testing auto-release',
    platforms='Posix; MacOS X; Windows',
    python_requires='==3.7.4',
)
