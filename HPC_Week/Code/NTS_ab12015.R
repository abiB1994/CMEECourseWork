rm(list=ls())
graphics.off()

#Creating a vector of individuals called community and creating function to output species richness of community


species_richness = function(community){
  length(unique(community))
}

#Creating a function to generate an initial state with maximum possible no. of spec

initialise_max = function(size){
  return(seq(size))
}

#Creating initialise_min function

initialise_min = function(size){
  return(rep(1,size))
}


#Testing so far
#print(species_richness(initialise_min(90)))
#print(species_richness(initialise_max(45)))

#Writing choose_two function
choose_two = function(x){
  sample(x,2)
}

#Writing neutral step

neutral_step = function(community){
  choosing <- choose_two(length(community))
  die <- choosing[1]
  replace <- choosing[2]
  community[die] = community[replace]
  return(community)
}

#Neutral generation function

neutral_generation = function(community){
  len = ceiling(length(community))
  for (i in 1:len){
    community <- neutral_step(community)
  }
  return(community)
}

#Function neutral_time_series

neutral_time_series = function(initial, duration){
  rich <- c(species_richness(initial))
  for (i in 1:duration){
    step <- neutral_generation(initial)
    initial = step
    rich <- c(rich, species_richness(initial))
  }
  return(rich)
}


#Question 8

question_8 = function(){
  plot(neutral_time_series(initialise_max(100), 200), xlab = "Generation time", ylab = "Species richness", main = "Question Eight")
}


#Adding speciation

neutral_step_speciation = function(community, v){
  prob = runif(1)
  if (prob > v){
    choosing <- choose_two(length(community))
    die <- choosing[1]
    replace <- choosing[2]
    community[die] = community[replace]
  }
  else {
    x <- sample(length(community), 1)
    specie_id = max(unique(community))
    community[x] = specie_id+1
  }
  return(community)
}


#Generation_speciation

neutral_generation_speciation = function(community, v){
  len = ceiling(length(community))
  for (i in 1:len){
    community <- neutral_step_speciation(community,v)
  }
  return(community)
}

#New function : Time series with speciation

neutral_time_series_speciation = function(initial, v, duration){
  rich <- c(species_richness(initial))
  for (i in 1:duration){
    step <- neutral_generation_speciation(initial, v)
    initial = step
    rich <- c(rich, species_richness(initial))
  }
  return(rich)
}


#Initialising constants for Q12 

spec_rate = 0.1    
J = initialise_max(100)
generation = 200
X = initialise_min(100)
x1 = neutral_time_series_speciation(J, spec_rate, generation)


question_12 = function(){
  plot(neutral_time_series_speciation(J, spec_rate, generation), ylim = range(0,100), xlab = "Generation time", ylab = "Species richness", main = "Question Twelve", col = "red")
  points(neutral_time_series_speciation(X, spec_rate, generation), col="green", ylim = range(0,100))
}



#Species abundance function

species_abundance = function(community){
  return(as.numeric(sort(table(community))))
}



#Octaves function

octaves = function(spec){
  return(tabulate(floor(log2(spec)) + 1))
}

#Sum Funct

sum_vect = function(x,y){
  x1 = length(x)
  y1 = length(y)
  if (x1 == y1){
    return(x + y)
  } else if (x1 > y1){
    dif = x1 - y1
    y = c(y, rep(0, dif))
    return(x + y)
  } else{
    dif = y1 - x1
    x = c(x, rep(0,dif))
    return(x+ y)
  }
}

#Exp
neutral_time_series_speciation_nsr = function(initial, v, duration){
  community = initial
  spec_a <- list(octaves(species_abundance(initial)))
  for (i in 1:duration){
    community <- neutral_generation_speciation(community, v)
    temp_a = octaves(species_abundance(community))
    spec_a = c(spec_a, list(temp_a))
  }
  return(spec_a)
}

abi_spec_rate = 0.003596

#Question 16

# %% remainder i.e. 7 %% 2 = 1 as 7/2 3 times, with 1 leftover

#Question 16
Question_16 = function(){
  plotty = neutral_time_series_speciation_nsr(J, spec_rate, 2000)
  for_plot = plotty[[220]] #Inc 220 is 1st after burnin
  c = 1
  for (i in 221:2001){      #After the "burn in period"
    if (i %% 20 == 0){
      c = c + 1
      for_plot = sum_vect(for_plot, plotty[[i]]) #Recording species abundance octaves as vector
     }
  }
  for_plot = for_plot/ c #Calc average
  xx <- barplot(for_plot, xlab = "Number of individuals", ylab = "Species abundance") 
  ## Add text at top of bars
  text(x = xx, y = for_plot, label = round(for_plot, 1), pos = 3, cex = 0.8, col = "red")
}

#Plotting species rich as function of time


#Challenge A


# 
# multi_run = replicate(100, neutral_time_series_speciation(X, spec_rate, generation))
# len = nrow(multi_run) # running simulation multiple times
# multi_run2 = replicate(100, neutral_time_series_speciation(J, spec_rate, generation))
# len = nrow(multi_run2)

total_average = function(mult){ #creating total average function, couldn't figure out lappy with the replicate outcome
  total_av = mean(mult[1,])
  for (i in 2:len){
    av = mean(mult[i,])
    total_av = c(total_av, av)
  }
  return(total_av)
}

total_sd = function(mult){ #total sd function
  total_std = sd(mult[1,])
  for (i in 2:len){
    standd = sd(mult[i,])
    total_std = c(total_std, standd)
  }
  return(total_std)
}
#std1 = total_sd(multi_run)

CI = function(av, std){ # Confidence interval function
  error = qnorm(0.986) * (std[1]/sqrt(len))
  top = av[1] + error
  bottom = av[1] - error
  tot_top = top
  tot_bot = bottom
  for (i in 2:len){
    error = qnorm(0.986) * (std[i]/sqrt(len))
    top = av[i] + error
    bottom = av[i] - error
    tot_top = c(tot_top, top)
    tot_bot = c(tot_bot, bottom)
  }
  return(list(tot_top,tot_bot))
}

# 
# means1 = total_average(multi_run)
# means2 = total_average(multi_run2)
# std2 = total_sd(multi_run2)
# CI2 = CI(means2, std2)
# CI1 = CI(means1,std1)
# question_challengeA = function(){
#     plot(means1, xlab = "Generation time", ylab = "Species richness", main = "Challenge A", col = "red", cex = 0.2, type = "l", ylim = range(0,100))
#   lines(CI1[[1]], col="green")
#   lines(CI1[[2]], col ="green")
#   lines(means2,  col = "red", cex = 0.2)
#   lines(CI2[[1]], col="green")
#   lines(CI2[[2]], col ="green")
# }




#Challenge_B


#replica = function(){
#  i = 1
#  for (i in 1:10){
#    run_list = c()
#    run = replicate(100, neutral_time_series_speciation(c(initialise_min(i * 10),initialise_max(100 - (i*10))), spec_rate, generation))
#    run_list = c(run_list, run)
#    i = i+1
#    return(run_list)
#  }
#}

#a = replica()
# 
# 
# run1 = replicate(100, neutral_time_series_speciation(c(initialise_min(30),initialise_max(70)), spec_rate, generation))
# run2 = replicate(100, neutral_time_series_speciation(c(initialise_min(50),initialise_max(50)), spec_rate, generation))
# run3 = replicate(100, neutral_time_series_speciation(c(initialise_min(20),initialise_max(80)), spec_rate, generation))
# run4 = replicate(100, neutral_time_series_speciation(c(initialise_min(60),initialise_max(40)), spec_rate, generation))
# run5 = replicate(100, neutral_time_series_speciation(c(initialise_min(10),initialise_max(90)), spec_rate, generation))
# run6 = replicate(100, neutral_time_series_speciation(c(initialise_min(80),initialise_max(20)), spec_rate, generation))
# run7 = replicate(100, neutral_time_series_speciation(c(initialise_min(90),initialise_max(10)), spec_rate, generation))
# run8 = replicate(100, neutral_time_series_speciation(c(initialise_min(40),initialise_max(60)), spec_rate, generation))
# run9 = replicate(100, neutral_time_series_speciation(c(initialise_min(70),initialise_max(30)), spec_rate, generation))
# run10 = replicate(100, neutral_time_series_speciation(c(initialise_min(0),initialise_max(100)), spec_rate, generation))
# run11 = replicate(100, neutral_time_series_speciation(c(initialise_min(100),initialise_max(0)), spec_rate, generation))
# 
# run1av = total_average(run1)
# run2av = total_average(run2)
# run3av = total_average(run3)
# run4av = total_average(run4)
# run5av = total_average(run5)
# run6av = total_average(run6)
# run7av = total_average(run7)
# run8av = total_average(run8)
# run9av = total_average(run9)
# run10av = total_average(run10)
# run11av = total_average(run11)
# 
# question_challengeB = function(){
#   cl = rainbow(11)
#   plot(run1av, xlab = "Generation time", ylab = "Species richness", main = "Challenge B", col = cl[1], cex = 0.2, type = "l", ylim = range(0,100))
#   lines(run2av, col= cl[2])
#   lines(run3av, col = cl[3])
#   lines(run4av, col = cl[4])
#   lines(run5av, col= cl[5])
#   lines(run6av, col = cl[6])
#   lines(run7av, col = cl[7])
#   lines(run8av, col = cl[8])
#   lines(run9av, col = cl[9])
#   lines(run10av, col = cl[10])
#   lines(run11av, col = cl[11])
# }




