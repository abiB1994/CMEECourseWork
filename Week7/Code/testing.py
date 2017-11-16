import os

root_dir = '.'


# Create a list to store the results.
FilesDirsStartingWithC = []
OUTPUT_FILE = open('../Results/output.log',"w")

for directory, subdirectories, files in os.walk(root_dir):
	for file in files:
		if file.lower().startswith("c"):
			FilesDirsStartingWithC += file

FilesDirsStartingWithC

OUTPUT_FILE.write(FilesDirsStartingWithC)

