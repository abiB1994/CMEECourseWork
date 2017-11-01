# !usr/bin/envs python

import csv

with open('DNA.csv','rb') as csvFile:
    reader = csv.reader(csvFile)
    column_names_list = reader.next()
    seq1 = reader.next()
    seq2 = reader.next()


print seq1, seq2
# assign the longest sequence s1, and the shortest to s2
# l1 is the length of the longest, l2 that of the shortest

l1 = len(seq1[0])
l2 = len(seq2[0])
if l1 >= l2:
    s1 = seq1[0]
    s2 = seq2[0]
else:
    s1 = seq2[0]
    s2 = seq1[0]
    l1, l2 = l2, l1 # swap the two lengths

# function that computes a score
# by returning the number of matches 
# starting from arbitrary startpoint
def calculate_score(s1, s2, l1, l2, startpoint):
    # startpoint is the point at which we want to start
    matched = "" # contains string for alignement
    score = 0
    for i in range(l2):
        if (i + startpoint) < l1:
            # if its matching the character
            if s1[i + startpoint] == s2[i]:
                matched = matched + "*"
                score = score + 1
            else:
                matched = matched + "-"

    # build some formatted output
    print "." * startpoint + matched           
    print "." * startpoint + s2
    print s1
    print score 
    print ""

    return score

calculate_score(s1, s2, l1, l2, 0)
calculate_score(s1, s2, l1, l2, 1)
calculate_score(s1, s2, l1, l2, 5)

# now try to find the best match (highest score)
my_best_align = None
my_best_score = -1

for i in range(l1):
    z = calculate_score(s1, s2, l1, l2, i)
    if z > my_best_score:
        my_best_align = "." * i + s2
        my_best_score = z

print my_best_align
print s1
print "Best score:", my_best_score

best_score = "Best score:" + str(my_best_score)
with open('My_best.txt', 'w') as output:
    output.write(my_best_align + "\n")
    output.write(s1 + "\n")
    output.write(best_score)
    
output.close()
csvFile.close()
