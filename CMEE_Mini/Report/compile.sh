#!/bin/bash
pdflatex $1.tex
pdflatex $1.tex
biber $1
pdflatex $1.tex
evince $1.pdf &
