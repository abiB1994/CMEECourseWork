MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv") # loading in data

l = length(MyDF$Prey.mass)
for (i in 1:l){
  if (MyDF$Prey.mass.unit[i] == "mg") {
    MyDF$Prey.mass[i] = MyDF$Prey.mass[i] / 1000
    MyDF$Prey.mass.unit[i] = "g"
  }
}

library(lattice)
library(plyr)
pdf("../Results/Pred_Lattice.pdf", 11.7, 8.3) # ready to save 1st graph
histogram(~log(Predator.mass), data =MyDF)

dev.off()

pdf("../Results/Prey_Lattice.pdf", 11.7, 8.3) # graph 2
histogram(~log(Prey.mass), data = MyDF)

dev.off()

pdf("../Results/SizeRatio_Lattice.pdf", 11.7, 8.3) # graph 3
histogram(~log((Predator.mass) /(Prey.mass)), data =MyDF)

dev.off()

PP_Results <- ddply(MyDF, ~ Type.of.feeding.interaction, summarize, 
                    mean_mass_pred = mean(Predator.mass), median_mass_pred = median(Predator.mass), 
                    mean_mass_prey = mean(Prey.mass), median_mass_prey = median(Prey.mass),
                    mean_ppsize_ratio = mean(log(Predator.mass/Prey.mass)), 
                    median_ppsize_ratio = median(log(Predator.mass/Prey.mass)))

str(PP_Results)


write.csv(PP_Results, file = "../Results/PP_Results.csv")


