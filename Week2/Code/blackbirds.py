import re

# Read the file
f = open('../Data/blackbirds.txt', 'r')
text = f.read()
f.close()

# remove \t\n and put a space in:
text = text.replace('\t',' ')
text = text.replace('\n',' ')

# note that there are "strange characters" (these are accents and
# non-ascii symbols) because we don't care for them, first transform
# to ASCII:
text = text.decode('ascii', 'ignore')

# Now write a regular expression my_reg that captures # the Kingdom, 
# Phylum and Species name for each species and prints it out neatly:
my_reg2 = r'.*\bKingdom\b\s*([a-zA-Z]+)\s*.*\bPhylum\b\s*([a-zA-Z]+)\s*.*\bSpecies\b\s*([a-zA-Z]+\s[a-zA-Z]+)' 
my_reg = r'Kingdom\s*([a-zA-Z]+)|Phylum\s*([a-zA-Z]+)|\s*Species\s*([a-zA-Z]+\s[a-zA-Z]+)'         
kingdom_search = re.findall(my_reg, text)
kingdom2_search = re.findall(my_reg2, text)
# Hint: you will probably want to use re.findall(my_reg, text)...
# Keep in mind that there are multiple ways to skin this cat! 
text
print kingdom2_search
