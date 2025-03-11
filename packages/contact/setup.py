#!/usr/bin/env python

from setuptools import setup, find_packages

setup(name='contact',
      version='1.0',
      # Modules to import from other scripts:
      packages=find_packages(include=['utilities', 'utilities.*']),
      # Executables
      # scripts=["contact.main:main"],
      entry_points={
       'console_scripts': ['contact = contact.main:main'],
      }
      )
