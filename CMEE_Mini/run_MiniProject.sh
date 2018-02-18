#!/bin/bash
# Author: Abigail Baines a.baines17@imperial.ac.uk
# Script: run_MiniProject.sh
# Desc: shell script to run and compile project
# Arguments: none
# Date: Febuary 2018

cd Code


python Python_LMfitting.py

mv Rplots.pdf ../Results

cd ../Report
cd Sections 

texcount Abstract.tex Conclusion.tex Discussion.tex Introduction.tex Materials_Methods.tex Results.tex

cd ..
pdflatex Paper.tex
pdflatex Paper.tex
biber Paper
pdflatex Paper.tex
evince Paper.pdf &
