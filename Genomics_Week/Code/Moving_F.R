g <- read.table(file="../Population_Genomics_Practical/H938_chr15.geno", header=TRUE) 
library(dplyr)  #importing correct libraries
library(ggplot2)
library(reshape2)

g <- mutate(g, nObs = nA1A1 + nA1A2 + nA2A2) #adding 

g <- mutate(g, p11 = nA1A1/nObs , p12 = nA1A2/nObs, p22 = nA2A2/nObs ) 

g <- mutate(g, p1 = p11 + 0.5*p12, p2 = p22 + 0.5*p12)

#adding f col.
g <- mutate(g, F = (2*p1*(1-p1)-p12) / (2*p1*(1-p1)))
#plotting how it changes across chromo end to end
plot(g$F, xlab = "SNP number") 

movingavg <- function(x, n=5){stats::filter(x, rep(1/n,n), sides = 2)} 

 

plot.new()


pdf("../Results/Moving_F.pdf", 11.7, 8.3) # Preparing to save the graph

plot(movingavg(g$F), xlab="SNP number", ylab = "Moving average")

dev.off()