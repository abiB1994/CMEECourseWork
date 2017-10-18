# Runs the stochastic (with gaussian fluctuations) Ricker Eqn .

rm(list=ls())
set.seed(1)
stochrickvect<-function(p0 = runif(1000,.5,1.5),r=1.2,K=1,numyears=100, sigma = 0.2)
{
  #initialize
  N<-matrix(NA,numyears,length(p0))
  N[1,]<-p0
  
  for (yr in 2:numyears) #for each pop, loop through the years
  {
    N[yr,]<-N[yr-1,]*exp(r*(1-N[yr-1,]/K)+rnorm(length(p0),0,sigma))
  }
  return(N)
}
object <- stochrickvect()
# Now write another code called stochrickvect that vectorizes the above 
# to the extent possible, with improved performance: 

print("Vectorized Stochastic Ricker takes:")
print(system.time(res2<-stochrickvect()))
