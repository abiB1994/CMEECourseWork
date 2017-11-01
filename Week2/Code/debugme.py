#!/usr/bin/python

"""Testing the use of multiple debugging tools"""

__author__ = 'Abigail Baines a.baines17@imperial.ac.uk'
__version__ = '0.0.1'


def createabug(x):
	y = x**4
	import ipdb; ipdb.set_trace()
	z = 0.
	y = y/z
	return y

createabug(25)
