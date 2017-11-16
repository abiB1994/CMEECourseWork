""" The typical Lotka-Volterra Model simulated using scipy,
with appropriate parameters """

# !usr/bin/envs python

__author__ = 'Abigail Baines (a.baines17@imperial.ac.uk)'
__version__ = '0.0.1'

import numpy.random as npr
import numpy as np
import scipy as sc
import pylab as p #Contains matplotlib for plotting
import sys


def dR_dt(pops, t=0):
    """ Returns the growth rate of predator and prey populations at any
    given time step """

    R = pops[0]
    C = pops[1]
    Er = npr.normal(0, .1, len(t))
    Ec = npr.normal(0, .1, len(t))

    # Creating a while loop for discrete-time equation
    for t in range(1,len(t-1)):
        R[t] = int(R[t-1]*(1 + r + Er[t-1] + (1- R[t-1]/K) - a*C[t-1]))
        C[t] = int(C[t-1] * (1 - z + Ec[t-1] + e * a * R[t-1]))


    #dRdt = r * R * (1 - R / K) - a * R * C
    #dydt = -z * C + e * a * R * C

    return sc.array([R, C])


r = .5 # Resource growth rate
a = 0.1 # Consumer search rate (determines consumption rate)
z = 1 # Consumer mortality rate
e = .75 # Consumer production efficiency
K = 16 # Carrying capacity


# Now define time -- integrate from 0 to 15, using 1000 points:
t = sc.linspace(0, 40,  1000)


x0 = 20
y0 = 2
d = np.zeros((2, len(t)))
d[0][0] = x0 # initials conditions: 10 prey and 5 predators per unit area
d[1][0] = y0


dR_dt(d, t)

prey, predators = d # What's this for?
f1 = p.figure() #Open empty figure object
p.plot(t, prey, 'g-', label='Resource density') # Plot
p.plot(t, predators  , 'b-', label='Consumer density')
p.grid()
p.figtext(.8, .6, " r =" + str(r) + "\n a =" + str(a) + "\n z = " + str(z)
			+ "\n e = " + str(e) + "\n K = " + str(K))

p.legend(loc='best')
p.xlabel('Time')
p.ylabel('Population')
p.title('Consumer-Resource population dynamics')
p.show()

f1.savefig('../Results/prey_and_predators_5.pdf') #Save figure

print ("The preys final population density is: {0:.2f} and the final predators population: {1:.2f}".format(prey[-1], predators[-1]))

if __name__ == "__main__":
		sys.exit("I have exited now")