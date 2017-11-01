
MyDF <- read.csv("../Data/EcolArchives-E089-51-D1.csv") # loading in data
library(ggplot2)  #loading required packages
library(plyr)
library(data.table)

#Some mass values in mg, so looping through prey mass to convert them
l = length(MyDF$Prey.mass)
for (i in 1:l){
  if (MyDF$Prey.mass.unit[i] == "mg") {
    MyDF$Prey.mass[i] = MyDF$Prey.mass[i] / 1000
    MyDF$Prey.mass.unit[i] = "g"
  }
}

graph_pp <- ggplot(MyDF, aes(x = Prey.mass, y = Predator.mass, col = Predator.lifestage)) + geom_point(shape = 3) + geom_smooth(method = 'lm', fullrange = TRUE) + facet_grid(Type.of.feeding.interaction ~ .) + scale_y_continuous(trans = "log10") + scale_x_continuous(trans = "log10") + xlab("Prey Mass in grams") + ylab("Predator Mass in grams") + theme_bw() + theme(legend.position="bottom")+ coord_fixed(ratio = 0.3) #Creating the correct graph


pdf("../Results/PP_Regress.pdf", 11.7, 8.3) # Preparing to save the graph
print(graph_pp)

dev.off()

# take logs of the two mass columns

MyDF[["Predator.mass"]] = log(MyDF$Predator.mass)
MyDF[["Prey.mass"]] = log(MyDF$Prey.mass)

# 
# set.seed(1)
# 
# dt <- data.table(MyDF,key="Type.of.feeding.interaction")
# 
# fits <- lapply(unique(MyDF$Type.of.feeding.interaction),
#               function(z)lm(Prey.mass ~ Predator.lifestage + Type.of.feeding.interaction, data=dt, y=T))
# 
# sapply(fits, coef)
# 
# out <- capture.output(sapply(fits, coef), sapply(fits,function(x)c(se=summary(x)$sigma, rsq=summary(x)$r.squared)),sapply(fits, function(x)(summary(x)$fstatistic)),sapply(fits, function(x)c(pf(summary(x)$fstatistic[1],summary(x)$fstatistic[2],summary(x)$fstatistic[3],lower.tail=FALSE))), file="../Results/PP_Regress_Results.csv")
# 
# Nicer output, but I don't think it produces everything the practical asks for?
model1<- lm(Predator.mass ~ Type.of.feeding.interaction + Predator.lifestage,  data=MyDF)
anova(model1)

model2 <- lm(Prey.mass ~ Type.of.feeding.interaction + Predator.lifestage,  data=MyDF)
anova(model2)

out <- capture.output(anova(model1), summary(model1), anova(model2), summary(model2), file="../Results/PP_Regress_Results.csv")







