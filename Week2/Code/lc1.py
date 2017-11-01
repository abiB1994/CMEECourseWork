birds = ( ('Passerculus sandwichensis','Savannah sparrow',18.7),
          ('Delichon urbica','House martin',19),
          ('Junco phaeonotus','Yellow-eyed junco',19.5),
          ('Junco hyemalis','Dark-eyed junco',19.6),
          ('Tachycineata bicolor','Tree swallow',20.2),
         )

# !/usr/bin/env python

"""List comprehension and for loops to create multiple lists from tuple
of tuples"""

__author__ = "Abigail Baines a.baines17@imperial.ac.uk"
__version__ = '0.0.1'

#(1) Write three separate list comprehensions that create three different
# lists containing the latin names, common names and mean body masses for
# each species in birds, respectively. 

# (2) Now do the same using conventional loops (you can choose to do this 
# before 1 !). 

# ANNOTATE WHAT EVERY BLOCK OR, IF NECESSARY, LINE IS DOING! 

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT 
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS

#1

#creating list of latin names
latin1 = list(l[0] for l in birds)
print latin1

#creating list of common names 
common1 = list(l[1] for l in birds)
print common1

#creating list of mass
mass1 =  list(l[2] for l in birds)
print mass1

#2
latin2 = []		#Initialising empty lists
common2 = []
mass2 = []

for l in birds:			#for loop looping through each tuple in birds
	latin2.append(l[0])	# and appending correct value to each initialised
	common2.append(l[1])#list
	mass2.append(l[2])
	
print latin2, common2, mass2
	



