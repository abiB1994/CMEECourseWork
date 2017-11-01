# !/usr/bin/env python

"""Loops and infinite loops in python"""

__author__ = "Abigail Baines a.baines17@imperial.ac.uk"
__version__ = '0.0.1'

# for loops in Python
for i in range(5):
	print i

my_list = [0, 2, "geronimo!", 3.0, True, False]
for k in my_list:
	print k

total = 0
summands = [0, 1, 11, 111, 1111]
for s in summands:
	total = total + s
	print total

# while loops in Python
z = 0
while z < 100:
	z = z + 1
	print (z)
	
b = True
while b:
	print "GERONIMO! infinite loop! ctrl+c to stop!"
# ctrl + c to stop!
