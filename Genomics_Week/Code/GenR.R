g <- read.table(file="H938_chr15.geno", header=TRUE) 
head(g)#checking import
dim(g)

library(dplyr)  #importing correct libraries
library(ggplot2)
library(reshape2)
unique(g[["SNP"]])

g <- mutate(g, nObs = nA1A1 + nA1A2 + nA2A2) #adding a column
head(g)
summary(g$nObs)#checking new column

qplot(nObs, data = g) #plotting new column
a = min(g$nObs)#min value of nObs
gwm = a/19560 *100  #approx. 4% genomewide missingness rate

# Compute genotype frequencies

g <- mutate(g, p11 = nA1A1/nObs , p12 = nA1A2/nObs, p22 = nA2A2/nObs ) 

# Compute allele frequencies from genotype frequencies

g <- mutate(g, p1 = p11 + 0.5*p12, p2 = p22 + 0.5*p12) 
head(g)

qplot(p1, p2, data=g) 

#tidying data and then melting the df
gTidy <- select(g, c(p1,p11,p12,p22)) %>% melt(id='p1',value.name="Genotype.Proportion") 

#checking new df
head(gTidy)
dim(gTidy)

#plotting new plot
ggplot(gTidy) + geom_point(aes(x = p1,
                               
                               y = Genotype.Proportion,
                               
                               color = variable,
                               
                               shape = variable)) 

#adding hw lines to it
ggplot(gTidy)+ geom_point(aes(x=p1,y=Genotype.Proportion, color=variable,shape=variable))+ stat_function(fun=function(p) p^2, geom="line", colour="red",size=2.5) + stat_function(fun=function(p) 2*p*(1-p), geom="line", colour="green",size=2.5) + stat_function(fun=function(p) (1-p)^2, geom="line", colour="blue",size=2.5) 

#adding new column, chisq)
g <- mutate(g, X2 = (nA1A1-nObs*p1^2)^2 /(nObs*p1^2) + (nA1A2-nObs*2*p1*p2)^2 / (nObs*2*p1*p2) + (nA2A2-nObs*p2^2)^2 / (nObs*p2^2)) #chi sq and testing hw
g <- mutate(g,pval = 1-pchisq(X2,1)) 



head(g$pval) 

sum(g$pval < 0.05, na.rm = TRUE) 
qplot(pval, data = g) 

#plotting graph
qplot(2*p1*(1-p1), p12, data = g) + geom_abline(intercept = 0, slope=1, color="red", size=1.5) 

#adding f col.
g <- mutate(g, F = (2*p1*(1-p1)-p12) / (2*p1*(1-p1)))
#plotting how it changes across chromo end to end
plot(g$F, xlab = "SNP number") 


#The code above instructs the function to take 5 values centered on a focal SNP, weighting them each by 1/5 and then taking the sum. In this way it produces a local average in a sliding window of 5 SNPs. Let’s define the movingavg function and then make a plot of its values: 
movingavg <- function(x, n=5){stats::filter(x, rep(1/n,n), sides = 2)} 
plot(movingavg(g$F), xlab="SNP number") 


outlier=which (movingavg(g$F) == max(movingavg(g$F),na.rm=TRUE)) 
g[outlier,]
