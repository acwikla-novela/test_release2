import yaml
from setuptools import setup, find_packages


with open('meta.yaml') as config:
    config_dict = yaml.load(config, Loader=yaml.FullLoader)
    version = config_dict['package']['version']

setup(
    name='test_release2',
    version=version,
    author='Aleksander Cwikla',
    url="https://github.com/acwikla-novela/test_release2",
    packages=find_packages(),
    description='Testing auto-release',
    platforms='Posix; MacOS X; Windows',
    python_requires='==3.7.4',
)
