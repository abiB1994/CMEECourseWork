#!/usr/bin/env Rscript

rm(list=ls())
graphics.off()

#Creating a vector of individuals called community and creating function to output species richness of community

species_richness = function(community){
  length(unique(community))
}

#Initial min
initialise_min = function(size){
  return(rep(1,size))
}


#Writing choose_two function
choose_two = function(x){
  sample(x,2)
}

#Neutral step
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



#Species abundance function

species_abundance = function(community){
  return(as.numeric(sort(table(community))))
}

#Octaves function


###New work from here###


cluster_run = function(speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_gen, output_filename, iter){
  #output_filename = paste("../Results/", output_filename, sep = "")
  community = initialise_min(size)
  a <- as.numeric(proc.time())
  gen_no = 0
  spec_rich_store = c()
  spec_abundance_store = c()
  while ((as.numeric(proc.time()) - a)[3] < (wall_time * 60)) {
    temp = neutral_generation_speciation(community, speciation_rate)
    community = temp
    gen_no = gen_no + 1
    if ((gen_no < burn_in_gen) & (gen_no %% interval_rich == 0)){
      spec_rich_store = c(spec_rich_store, list(temp))
    } 
    if (gen_no %% interval_oct == 0){
      spec_abundance_store = c(spec_abundance_store, list(octaves(species_abundance(temp))))
    }
  }  
  save(community, spec_rich_store, spec_abundance_store, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_gen, file = paste(output_filename, iter, ".rda", sep = "_"))
}


#iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
#iter = 1

abi_spec_rate = 0.003596


size = function(iter1){
  if(as.numeric(iter1) <= 25){
    size = 500
  }
  else if (as.numeric(iter1) <= 50){
    size = 1000
  }
  else if (as.numeric(iter1) <= 75){
    size = 2500
  }
  else{
    size = 5000
  }
  return(size)
}


do_simulation = function(iter2){
  abi_spec_rate = 0.003596
  Si = size(iter2)
  set.seed(iter2)
  time_to_run = 690
  output_filename = "my_test_file"
  cluster_run(abi_spec_rate, Si, time_to_run , 1, (Si/10), (8*Si), "HPC_ab12015", iter2)
}

#do_simulation(1)
#do_simulation(iter)


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

calc = function(iterbegin){
  iter = iterbegin
  mean_store = c()
  vect = c()
  while (iter >= iterbegin & iter <= (iterbegin + 24)){
    file = paste("my_test_file", iter, ".rda", sep = "_")
    file = paste("../Results/", file, sep = "")
    load(file)
    n = as.numeric(length(spec_abundance_store))
    start_no = (burn_in_gen / interval_oct) + 1
    it = start_no
    if (n > start_no){
      for (it in start_no:(n-1)){
        summing = sum_vect(spec_abundance_store[[it]], spec_abundance_store[[it+1]])
        spec_abundance_store[[it+1]] = summing
      }
      summed = spec_abundance_store[[n]] / (n-81)
      mean_store = sum_vect(vect, summed)
      vect = mean_store
    }
    iter = iter + 1
  }
  return(mean_store / 25)
}

#Q 20
# names = c(1,2,3,4,5,6,7,8,9,10,11)
# abundance_500 = calc(1)
# abundance_1000 = calc(26)
# abundance_2500 = calc(51)
# abundance_5000 = calc(76)
# par(mfrow = c(2,2))
# plot_5000 <- barplot(abundance_5000, main = "Size = 5000", names.arg = names)
# plot_2500 <- barplot(abundance_2500, main =  "Size = 2500", names.arg = names)
# plot_1000 <- barplot(abundance_1000, main = "Size = 1000", names.arg = names[1:10])
# plot_500 <- barplot(abundance_500, main = "Size = 500", names.arg = names[1:9])


challenge_C = function(iterbegin){
  iter = iterbegin
  mean_store = c()
  vect = c()
  while (iter >= iterbegin & iter <= (iterbegin + 24)){
    file = paste("my_test_file", iter, ".rda", sep = "_")
    file = paste("../Results/", file, sep = "")
    load(file)
    n = length(spec_rich_store)/100
    start_no = 1
    it = start_no
    if (n > start_no){
      for (it in start_no:n){
        summing = length(unique(spec_rich_store[it:(it+99)]))
        vect = c(vect, summing)
        it = it + 99
      }
    }
    iter = iter + 1
    mean_store = sum_vect(mean_store, vect)
  }
  return(mean_store/25)
}

#richness_500 = challenge_C(1)
#x = 1:length(richness_500)
#plot(x =x, y =richness_500)

#odf =  data.frame(index = x, richness = richness_500)
#df = data.frame(index = x[1:50000], richness = richness_500[1:50000])
#df2 = data.frame(index = x[50001:100000], richness = richness_500[50001:100000])
#library(ggplot2)
# Basic line plot with points
#ggplot(data=df, aes(x=index, y=richness, group=1)) +
  #geom_point(size = 0.01)
#ggplot(data=df2, aes(x=index, y=richness, group=1)) +
  #geom_point(size = 0.01)
#ggplot(data=odf, aes(x=index, y=richness, group=1)) +
  #geom_point(size = 0.01)

################################################
#Challenge D
################################################

#Coalescence

lineages = function(j){
  return(rep(1, j))
}

challenge_D = function(N, iter ="2"){
  N = N
  a = as.numeric(proc.time())[3]   #Measuing time 
  abundances = c()   # initialising empty abundance vector
  j = N   # original length, j will always stay the same
  lineage = lineages(j)    #initialising lineage
  O = abi_spec_rate*((j - 1) / (1 - abi_spec_rate))  #creating o
  index_j = round(runif(1, 1, length(lineage))) # picking random index
  randnum = runif(1) # picking random number
  while ( N > 1){
    if (randnum < (O/ (O + (N - 1)))){
      abundances = c(abundances,lineage[index_j])  # Adding lineage to abundance
    }
    else{
      index_i = round(runif(1, 1, length(lineage)))
      if(index_i != index_j){
        lineage[index_i] = lineage[index_i] + lineage[index_j] #Speciation
      }
      else{
        next
      }
    }
    lineage = lineage[-(index_j)]  #Removing the added lineage
    N = N -1 #same here
    randnum = runif(1) #initialising new random number
    index_j = round(runif(1, 1, length(lineage))) # and new index
  }
  final_time = (as.numeric(proc.time())[3] - a)/60
  abundances = c(abundances, lineage)
  abundances = octaves(species_abundance(abundances))
  save(abundances, final_time, file = paste("../Results/Challenge_D", iter, ".rda", sep = "_" ))
}



do_simulation_CD = function(){ #Similar to do_sim for HPC, allowing 100 simulations to run
  a = as.numeric(proc.time())[3]
  iter = 1
  while (iter <101) {
  if (iter < 26){
    N = 500
    set.seed(iter)
    challenge_D(N, iter)
    iter = iter + 1
  }
  else if (iter < 51){
    N = 1000
    set.seed(iter)
    challenge_D(N, iter)
    iter = iter + 1
  }
  else if (iter < 76){
    N = 2500
    set.seed(iter)
    challenge_D(N, iter)
    iter = iter + 1
  }
  else if (iter < 101){
    N = 5000
    set.seed(iter)
    challenge_D(N, iter)
    iter = iter + 1
  }
  }
  return(as.numeric(proc.time())[3] - a)
}

#challenge_D(500)

for_plotting = function(){
  abundances_v = c()
  iter = 1
  while (iter < 26){
    file = paste("../Results/Challenge_D", iter, ".rda", sep = "_" )
    load(file)
    abundances_v = sum_vect(abundances_v, abundances)
    print(abundances_v)
    iter = iter + 1
  }
  return(abundances_v)
}

#plt = for_plotting()
#barplot(plt/25)
#graphics.off()  
