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

octaves = function(spec){
  return(tabulate(floor(log2(spec)) + 1))
}

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
      spec_rich_store = c(spec_rich_store, temp)
    } 
    if (gen_no %% interval_oct == 0){
      spec_abundance_store = c(spec_abundance_store, list(octaves(species_abundance(temp))))
    }
  }  
  save(community, spec_rich_store, spec_abundance_store, speciation_rate, size, wall_time, interval_rich, interval_oct, burn_in_gen, file = paste(output_filename, iter, ".rda", sep = "_"))
}


iter <- as.numeric(Sys.getenv("PBS_ARRAY_INDEX"))
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
  cluster_run(abi_spec_rate, Si, time_to_run , 1, (Si/10), (8*Si), "my_test_file", iter2)
}

#do_simulation(1)
do_simulation(iter)
