#!/bin/bash
latex $1.tex
latex $1.tex
biber $1
latex $1.tex
dvipdfm $1.dvi
evince $1.pdf &
