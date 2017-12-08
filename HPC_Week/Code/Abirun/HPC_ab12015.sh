#!/bin/bash
#PBS -l walltime=12:00:00
#PBS -l select=1:ncpus=1:mem=6gb
module load anaconda3/personal
Module load R
module load intel-suite
echo "R is about to run"
R --vanilla < $WORK/Abirun/HPC_ab12015.R
mv my_test_file* $WORK
echo "R has finished running"
# this is a comment at the end of the file
