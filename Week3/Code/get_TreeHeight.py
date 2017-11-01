#!/usr/bin/env python

__author__ = "Abi Baines a.baines17@imperial.ac.uk"
__version__ = "0.0.8"

""" Script to calculate tree height from distance and angle in a csv file
and to output the heights to a new csv file """

import os
import sys
import pandas as pd
import numpy as np
import re
import ntpath

MyData = [] # initialising empty list for future functions 

def getdata(f):
    """This function reads the data into a dataframe"""
    df = pd.read_csv(f)
    return df

#because the data is now in a dataframe, 
# columns can be operated on without the for loop

def calc_height(df):
    """This functions calculates height of the tree from distance and angle of elevation"""
    df['height'] = df['Distance.m'] * np.tan(np.deg2rad(df['Angle.degrees']))
    return df

def savedata(data,f):
    """This function creates correct output file name"""
    f = ntpath.basename(f).split('.')[0]
    addition = "_get_TreeHeight.csv"
    outname = f + addition
    path = "../Results/"
    outfilepath = os.path.join(path,outname)
    data.to_csv(outfilepath)


def main(argv):
		MyData = getdata(argv[1])
		MyData = calc_height(MyData)
		savedata(MyData,argv[1])


if (__name__ == "__main__"):
        status = main(sys.argv)
        sys.exit("I have excited now")
