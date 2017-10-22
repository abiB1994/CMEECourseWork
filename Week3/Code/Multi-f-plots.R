#Multi-faceted plots
#row
qplot(log(Prey.mass/Predator.mass),
      facets = Type.of.feeding.interaction ~. ,
      data = MyDF, geom = "density")
#column
qplot(log(Prey.mass/Predator.mass),
      facets = .~ Type.of.feeding.interaction,
      data = MyDF, geom = "density")
