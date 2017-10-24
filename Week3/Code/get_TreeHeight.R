args <- commandArgs(TRUE)
file_args <- read.csv(args[1], sep=",")
require(stringr)

TreeHeight <- function(degrees, distance){
  radians <- degrees * pi / 180
  height <- round(distance * tan(radians), digits = 2)
  print(paste("Tree height is:", height))
  
  return(height)
}

y = tools::file_path_sans_ext(gsub("../.*/", "", args[1]))

x = paste("../Results",paste(y, "treeheights.csv", sep = "_") , sep = "/")

write.csv(TreeHeight(file_args[,3], file_args[,2]), x)
