#ggplot

qplot(log(Prey.mass), log(Predator.mass),
      data = MyDF, colour = I("red"))
qplot(log(Prey.mass), log(Predator.mass),
      data = MyDF, size = 3) #with ggplot size mapping
qplot(log(Prey.mass), log(Predator.mass),
      data = MyDF, size = I(3))

#semi transparancy - alpha
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      colour = Type.of.feeding.interaction, alpha = I(.5))

#adding a smoother to the point
qplot(log(Prey.mass), log(Predator.mass), data = MyDF, geom = c("point","smooth"))

qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
      geom = c("point", "smooth")) + geom_smooth(method = "lm")

#adding smoother for each type of interaction
qplot(log(Prey.mass), log(Predator.mass), data = MyDF,
    geom = c("point", "smooth"), colour = Type.of.feeding.interaction)
    + geom_smooth(method = "lm", fullrange = TRUE)

#ratio of prey-pred according to type of interaction
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF)

#added jitter
qplot(Type.of.feeding.interaction, log(Prey.mass/Predator.mass), data = MyDF, geom = "jitter")

#boxplots
qplot(Type.of.feeding.interaction,
      log(Prey.mass/Predator.mass), data = MyDF,
      geom = "boxplot")

qplot(log(Prey.mass/Predator.mass), data = MyDF, geom = "histogram", binwidth = 2, bins = 20)

qplot(log(Prey.mass/Predator.mass), data = MyDF,
      geom = "histogram",
      fill = Type.of.feeding.interaction)

qplot(log(Prey.mass/Predator.mass), data = MyDF,
      geom = "histogram",
      fill = Type.of.feeding.interaction,
      binwidth = 1)

#Density transparent
qplot(log(Prey.mass/Predator.mass), data = MyDF,
      geom = "density", fill = Type.of.feeding.interaction, alpha =
        I(0.5))
#colour = draws only the edge of the curve
qplot(log(Prey.mass/Predator.mass), data = MyDF,
      geom = "density", colour = Type.of.feeding.interaction)











