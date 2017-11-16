""" The typical Lotka-Volterra Model simulated using scipy """

import scipy as sc 
import scipy.integrate as integrate
import pylab as p #Contains matplotlib for plotting

# import matplotlip.pylab as p #Some people might need to do this

import sys


def dR_dt(pops, t=0):
    """ Returns the growth rate of predator and prey populations at any 
    given time step """
    
    R = pops[0]
    C = pops[1]
    dRdt = r*R*(1 - R/K) - a*R*C 
    dydt = -z*C + e*a*R*C
    
    return sc.array([dRdt, dydt])

# Define parameters:
r = int(sys.argv[1]) # Resource growth rate
a = int(sys.argv[2]) # Consumer search rate (determines consumption rate)
z = int(sys.argv[3]) # Consumer mortality rate
e = int(sys.argv[4]) # Consumer production efficiency
K = int(sys.argv[5]) # Carrying capacity


# Now define time -- integrate from 0 to 15, using 1000 points:
t = sc.linspace(0, 50, 1000)
print t 

x0 = 10
y0 = 5 
z0 = sc.array([x0, y0]) # initials conditions: 10 prey and 5 predators per unit area

pops, infodict = integrate.odeint(dR_dt, z0, t, full_output=True)

print infodict['message']     # >>> 'Integration successful.'

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
f1.savefig('../Results/prey_and_predators_2.pdf') #Save figure

if __name__ == "__main__":
		sys.exit("I have exited now")
