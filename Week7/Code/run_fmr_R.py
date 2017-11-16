#!usr/bin/envs python

__author__ = "Abigail Millward a.baines17@imperial.ac.uk"
__version__ = "0.0.1"

import io
import time
import subprocess
import sys

filename = 'test_R_fmr.log'
with io.open(filename, 'wb') as writer, io.open(filename, 'rb', 1) as reader:
    process = subprocess.Popen(["Rscript", "fmr.R"], stdout=writer)
    while process.poll() is None:
        sys.stdout.write(str(reader.read()))
        time.sleep(0.5)
    # Read the remaining
    sys.stdout.write(str(reader.read()))
