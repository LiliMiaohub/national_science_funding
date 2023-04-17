#!/usr/bin/env python
# encoding: utf-8

from distutils.core import setup
from setuptools import find_packages, setup

setup(name='funding', 
      version='0.1', 
      description = 'package for national funding project', 
      author = "Lili Miao", 
      packages = find_packages(exclude=("tests",)),
      install_requires=['matplotlib','geopandas']
)
