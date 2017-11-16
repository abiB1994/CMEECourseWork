""" The typical Lotka-Volterra Model simulated using scipy,
with appropriate parameters """

# !usr/bin/envs python

__author__ = 'Abigail Baines (a.baines17@imperial.ac.uk)'
__version__ = '0.0.1'

import scipy as sc
import scipy.integrate as integrate
import pylab as p #Contains matplotlib for plotting
import sys


def dR_dt(pops, t=0):
    """ Returns the growth rate of predator and prey populations at any
    given time step """

    R = pops[0]
    C = pops[1]
    dRdt = r * R * (1 - R / K) - a * R * C
    dydt = -z * C + e * a * R * C

    return sc.array([dRdt, dydt])


r = .5 # Resource growth rate
a = 0.1 # Consumer search rate (determines consumption rate)
z = 1.5 # Consumer mortality rate
e = .75 # Consumer production efficiency
K = 30 # Carrying capacity


# Now define time -- integrate from 0 to 15, using 1000 points:
t = sc.linspace(0, 40,  1000)


x0 = 15
y0 = 4
z0 = sc.array([x0, y0]) # initials conditions: 10 prey and 5 predators per unit area

pops, infodict = integrate.odeint(dR_dt, z0, t, full_output=True)

print (infodict['message'])     # >>> 'Integration successful.'

prey, predators = pops.T # What's this for?
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

f1.savefig('../Results/prey_and_predators_3.pdf') #Save figure
prey = list(pops.T[1])
pred = list(pops.T[0])

print ("The preys final population density is: {0:.2f} and the final predators population: {1:.2f}".format(prey[-1], pred[-1]))

if __name__ == "__main__":
		sys.exit("I have exited now")