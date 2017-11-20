#!/usr/bin/bash

python2.7 -m cProfile -o ../Results/LV1.cprof LV1.py
pyprof2calltree -k -i ../Results/LV1.cprof

python2.7 LV2.py .8 .1 1.5 .75 30

python LV3.py

python LV4.py

python LV5.py
