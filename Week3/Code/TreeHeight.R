# This function calculates heights of trees given distance of each tree
# from its base and angle to its top, using the trigonometric formula
# height = distance * tan(radians)
# ARGUMENTS:
# degrees
# distance
# The angle of elevation in radians
# The distance from base (e.g., meters)
#
# OUTPUT:
# The heights of the tree, same units as "distance"

tree = read.csv("../Data/trees.csv")
TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- round(distance * tan(radians), digits = 2)
  print(paste("Tree height is:", height))
  
  return(height)
}

TreeHeight(41.3, 31.7)

Tree.Height.m = TreeHeight(tree[,3], tree[,2])

tree$Tree.Height.m <- Tree.Height.m

write.csv(tree, "../Results/TreeHts.csv")


