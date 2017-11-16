#!/bin/bash -x
# Author: Abigail Baines a.baines17@imperial.ac.uk
# Script: running_excercises.sh
# Desc: Command line answers to excercise questions
# Arguments: none
# Date: November 2017

#No. of samples
wc –l ../Data/Dataset1/ME_Dataset1.fam

#No. of SNPs
wc –l ../Data/Dataset1/ME_Dataset1.bim

#Calls plink for --bfile flaf. freqx gives instructions (count geno)
Plink --bfile ../Data/Dataset1/ME_Dataset1 --freqx --out ../Results/ME_Dataset1

#looking at geno freqs.
head ../Results/ME_Dataset1.frqx

#using frqx2geno script to get data in correct output format
perl frqx2geno.pl ../Results/ME_Dataset1.frqx ../Results/ME_Dataset1.geno

#executing R script to make a graph
Rscript Ob_v_Ex_het.R ../Results/ME_Dataset1.geno ../Results/ME_Dataset1_ObvEx_het.pdf

#plotting moving F values
Rscript Moving_F.R ../Results/ME_Dataset1.geno ../Results/ME_Dataset1_F.pdf

#Using plink to test for HWE on each SNP
Plink --bfile ../Data/Dataset1/ME_Dataset1 --hardy --out ../Results/ME_Dataset1

#looking at output file
head ../Results/ME_Dataset1.hwe

#finding the 50 SNPs with greatest depart from HWE - values are on 9th column
#-k9 command sorts from greatest to smallest
sort -k 9 ../Results/ME_Dataset1.hwe | tail -n -50 > ../Results/ME_Dataset1_HWE_outliers.txt
