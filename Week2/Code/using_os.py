""" This is as script running subprocess to get dir,subdir, 
files beginning with C or c in home directory"""

# Use the subprocess.os module to get a list of files and  directories 
# in your ubuntu home directory 

# Hint: look in subprocess.os and/or subprocess.os.path and/or 
# subprocess.os.walk for helpful functions

import subprocess
import os
import shlex
from subprocess import check_output


# Get the user's home directory.
home = subprocess.os.path.expanduser("~")

#~ # Create a list to store the results.
#~ FilesDirsStartingWithC = []

#~ def is_a_c(name):
	#~ return name.lower().startswith("c")
#~ # Use a for loop to walk through the home directory.
#~ for (dir, subdir, files) in subprocess.os.walk(home):

OUTPUT_FILE = '../Results/output.log'



with open(OUTPUT_FILE, 'w') as output:
    for parent, _, _ in subprocess.os.walk(home):
			os.chdir(parent)
			output.write(check_output(shlex.split('tree -P ''c*')))
			output.write(check_output(shlex.split('tree -P ''C*')))

