#!/bin/bash
pdflatex $1.tex
pdflatex $1.tex
bibtex $1
pdflatex $1.tex
pdflatex $1.tex
evince $1.pdf &
##
rm
rm
rm
rm
rm
rm
rm
rm
Cleanup
* ∼
*.aux
*.dvi
*.log
*.nav
*.out
*.snm
*.toc
