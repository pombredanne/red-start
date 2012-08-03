#!/usr/bin/env python
from distutils.core import setup
import glob
import os

base_path = os.path.abspath(os.path.join(os.path.dirname(__file__), 'red_start'))

data_files = []
for dirpath, dirnames, filenames in os.walk(os.path.join(base_path, 'templates')):
    # Ignore dirnames that start with '.'
    for i, dirname in enumerate(dirnames):
        if dirname.startswith('.'): del dirnames[i]
    files = [os.path.join(dirpath, f)[len(base_path)+1:] \
                            for f in filenames if not f.endswith('.pyc')]
    data_files.extend(files)

setup(
    name='red-start',
    version='0.1.2',
    description='Create a Django project based on FF0000 best practices.',
    author='RED Interactive Agency',
    author_email='geeks@ff0000.com',
    url='http://github.com/ff0000/red-start/',
    packages=[
        'red_start',
    ],
    package_data={ 'red_start' : data_files },
    scripts=['bin/red-start'],
    classifiers=[
          'Development Status :: 3 - Alpha',
          'Environment :: Web Environment',
          'Framework :: Django',
          'Intended Audience :: Developers',
          'License :: OSI Approved :: MIT License',
          'Operating System :: OS Independent',
          'Programming Language :: Python',
          'Topic :: Utilities'
    ]
)
