g <- read.table(file="../Population_Genomics_Practical/H938_chr15.geno", header=TRUE) 
library(dplyr)  #importing correct libraries
library(ggplot2)
library(reshape2)

g <- mutate(g, nObs = nA1A1 + nA1A2 + nA2A2) #adding 

g <- mutate(g, p11 = nA1A1/nObs , p12 = nA1A2/nObs, p22 = nA2A2/nObs ) 

g <- mutate(g, p1 = p11 + 0.5*p12, p2 = p22 + 0.5*p12)

#adding new column, chisq)
g <- mutate(g, X2 = (nA1A1-nObs*p1^2)^2 /(nObs*p1^2) + (nA1A2-nObs*2*p1*p2)^2 / (nObs*2*p1*p2) + (nA2A2-nObs*p2^2)^2 / (nObs*p2^2)) #chi sq and testing hw
g <- mutate(g,pval = 1-pchisq(X2,1)) 

graph1 <- qplot(2*p1*(1-p1), p12, data = g) + geom_abline(intercept = 0, slope=1, color="red", size=1.5) + xlab("Observed") + ylab("Expected")

pdf("../Results/Ob_VS_EXP.pdf", 11.7, 8.3) # Preparing to save the graph
print(graph1)

dev.off()