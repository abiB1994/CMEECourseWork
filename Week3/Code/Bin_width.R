# basic plotting in R

# plot(y∼x) Scatterplot with y as a response variable

# predator and prey bin widths
par(mfcol= c(2,1)) #initialize multi-paneled plot
par(mfg = c(1,1)) # specify which sub-plot to use first
hist(log(MyDF$Predator.mass),
     xlab = "Predator Mass (kg)", ylab = "Count", breaks = 20, main = "Predator body masses") # include labels
par(mfg = c(2,1))
hist(log(MyDF$Prey.mass),
     xlab =  "Prey Mass (kg)", ylab = "Count", breaks = 20, main = "Prey body masses")
