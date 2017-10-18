#!/bin/bash
# Author: Abigail Baines a.baines17@imperial.ac.uk
# Script: csvtospace.sh
# Desc: substitute the csv to space seperated
# saves the output into a .txt file
# Arguments: 1-> csv file
# Date: Oct 2017

echo "Creating a space seperated version of $1..."

cat $1 | tr -s "," " " >> $1.txt

echo "All finished!"

exit
