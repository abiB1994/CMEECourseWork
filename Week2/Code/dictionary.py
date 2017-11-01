
# !/usr/bin/env python

"""Programme that creates a dictionary from list taxa"""

__author__ = "Abigail Baines a.baines17@imperial.ac.uk"
__version__ = '0.0.1'



taxa = [ ('Myotis lucifugus','Chiroptera'),
         ('Gerbillus henleyi','Rodentia',),
         ('Peromyscus crinitus', 'Rodentia'),
         ('Mus domesticus', 'Rodentia'),
         ('Cleithrionomys rutilus', 'Rodentia'),
         ('Microgale dobsoni', 'Afrosoricida'),
         ('Microgale talazaci', 'Afrosoricida'),
         ('Lyacon pictus', 'Carnivora'),
         ('Arctocephalus gazella', 'Carnivora'),
         ('Canis lupus', 'Carnivora'),
        ]

# Write a short python script to populate a dictionary called taxa_dic 
# derived from  taxa so that it maps order names to sets of taxa. 
# E.g. 'Chiroptera' : set(['Myotis lucifugus']) etc. 

# ANNOTATE WHAT EVERY BLOCK OR IF NECESSARY, LINE IS DOING! 

# ALSO, PLEASE INCLUDE A DOCSTRING AT THE BEGINNING OF THIS FILE THAT 
# SAYS WHAT THE SCRIPT DOES AND WHO THE AUTHOR IS

# Write your script here:


from collections import defaultdict #importing necessary modules

taxa_dic = defaultdict( list )  # initialising empty dictionary that 
								# takes values as lists

for v, k in taxa:				# looping over taxa to create the dic
	taxa_dic[k].append(v)		# for every 'key' in taxa, the value
								#is appended to the value list
print taxa_dic["Rodentia"]

#It worked!

	


	
