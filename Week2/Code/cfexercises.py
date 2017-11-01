# How many times will 'hello' be printed?

""" Control flow exercises in practise"""

__author__ = 'Abigail Baines (a.baines17@imperial.ac.uk)'
__version__ = '0.0.1'

import sys 
import re

# 1)
for i in range(3, 17):
	print 'hello'

# 2)
for j in range(12):
	if j % 3 == 0:
		print 'hello'

# 3)
for j in range(15):
	if j % 5 == 3:
		print 'hello'
	elif j % 4 == 3:
		print 'hello'

# 4)
z = 0
while z != 15:
	print 'hello'
	z = z + 3

# 5)
z = 12
while z < 100:
	if z == 31:
		for k in range(7):
			print 'hello'
	elif z == 18:
		print 'hello'
	z = z + 1

# What does fooXX do?
def foo1(x):
	return int(x) ** 0.5


def foo2(x, y):
	if int(x) > int(y):
		return x
	return y

def foo3(x, y, z):
	x = int(x)
	y = int(y)
	z = int(z)
	if x > y:
		tmp = y
		y = x
		x = tmp
	if y > z:
		tmp = z
		z = y
		y = tmp
	return [x, y, z]

def foo4(x):
	result = 1
	for i in range(1, int(x) + 1):
		result = result * i
	return result

# This is a recursive function, meaning that the function calls itself
# read about it at
# en.wikipedia.org/wiki/Recursion_(computer_science)
def foo5(x):
	if x == 1:
		return 1
	return int(x) * foo5(int(x) - 1)

foo5(10)

def main(argv):
	if len(argv) > 1:
		# sys.exit("don't want to do this right now!")
		print foo1(argv[1])
		print foo2(argv[2], argv[3])
		print foo3(argv[3], argv[3], argv[4])
		print foo4(argv[4])
		print foo5(argv[5])
	else:
		print foo1(input("Enter a number:"))
		int_list = [int(x) for x in raw_input("Enter 2 numbers:").split()]
		print foo2(int_list[0], int_list[1])
		int_list = [int(x) for x in raw_input("Enter 3 numbers:").split()]
		print foo3(int_list[0], int_list[1], int_list[2])
		print foo4(input("Enter a number:"))
		print foo5(input("Enter a number:"))
	
	return 0


if __name__ == "__main__":
	status = main(sys.argv)
	sys.exit(status)
