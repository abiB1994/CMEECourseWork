# Average UK Rainfall (mm) for 1910 by month
# http://www.metoffice.gov.uk/climate/uk/datasets
rainfall = (('JAN',111.4),
            ('FEB',126.1),
            ('MAR', 49.9),
            ('APR', 95.3),
            ('MAY', 71.8),
            ('JUN', 70.2),
            ('JUL', 97.1),
            ('AUG',140.2),
            ('SEP', 27.0),
            ('OCT', 89.4),
            ('NOV',128.4),
            ('DEC',142.2),
           )
# !/usr/bin/env python

"""List comprehension and for loops to create multiple lists from tuple
of tuples"""

__author__ = "Abigail Baines a.baines17@imperial.ac.uk"
__version__ = '0.0.1'

# (1) Use a list comprehension to create a list of month,rainfall tuples where
# the amount of rain was greater than 100 mm.
 
# (2) Use a list comprehension to create a list of just month names where the
# amount of rain was less than 50 mm. 

# (3) Now do (1) and (2) using conventional loops (you can choose to do 
# this before 1 and 2 !). 

# ANNOTATE WHAT EVERY BLOCK OR IF NECESSARY, LINE IS DOING! 

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT 
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS



#1
rain_100 = list(tuple( t for t in rainfall if t[1] > 100)) # rain 
													#greater than 100mm lc
print rain_100
#2
rain_50 = list(tuple( t for t in rainfall if t[1] < 50)) # rain less than
														# 50mm
print rain_50

#3
rain_100_for = [] 		#initialising empty list
for t in rainfall:		#creating for loop
	if t[1] > 100 :			# creating requirements to satisfy
		rain_100_for.append(t)	#appending satisfactory t values to list
	else:
		continue

print rain_100_for

#4
rain_50_for = [] 		#initialising empty list
for t in rainfall:		#creating for loop
	if t[1] < 50 :			# creating requirements to satisfy
		rain_50_for.append(t)	#appending satisfactory t values to list
	else:
		continue

print rain_50_for




