rm(list=ls())
graphics.off()

#x = a + ib

width1 <- 3
size1 <- 8

#size1 = width1^x
#log(size1) = log(width1^x)
#log(size1) = x * log(width1)
x = log(size1)/log(width1)

#The first object has a dimension of 1.893

width2 <- 3
size2 <- 20

x = log(size2)/log(width2)

#Second dimension is 2.727





chaos_game = function(){
  graphics.off()
  a = c(0,0)
  b = c(3,4)
  c = c(4,1)
  to_samp = list(a,b,c)
  x0 = c(0,0)
  plot(0:5, 0:5, type = "n")
  #axis(side = 1)
  #axis(side = 2)
  points(x = x0[1],y= x0[2], cex = 0.2)
  i = 1
  while (i <= 1000) {
    samp = sample(c(1,2,3), 1)
    x = c((to_samp[[samp]][1]), to_samp[[samp]][2])
    new_point = c(((x0[1] + x[1])/2), ((x0[2] + x[2])/2))
    points(x = new_point[1], y = new_point[2], cex = 0.2)
    x0 = new_point
    i = i +1
  }
}



challenge_E = function(){
  graphics.off()
  a = c(0,0)
  b = c(3,4)
  c = c(4,1)
  to_samp = list(a,b,c)
  x0 = c(2,4)
  plot(0:5, 0:5, type = "n")
  #axis(side = 1)
  #axis(side = 2)
  points(x = x0[1],y= x0[2], col = "green", pch = 23)
  i = 1
  n = 1
  while (i <= 10000) {
    while (n <= 100) {
      cl <- rainbow(100)
      samp = sample(c(1,2,3), 1)
      x = c((to_samp[[samp]][1]), to_samp[[samp]][2])
      new_point = c(((x0[1] + x[1])/2), ((x0[2] + x[2])/2))
      points(x = new_point[1], y = new_point[2], col = cl[n], pch = 23)
      x0 = new_point
      i = i +1
      n = n+1
    }
    samp = sample(c(1,2,3), 1)
    x = c((to_samp[[samp]][1]), to_samp[[samp]][2])
    new_point = c(((x0[1] + x[1])/2), ((x0[2] + x[2])/2))
    points(x = new_point[1], y = new_point[2], cex = 0.2)
    x0 = new_point
    i = i +1
  }
}




challenge_E2 = function(){
  graphics.off()
  a = c(0,0)
  b = c(2,4)
  c = c(4,0)
  to_samp = list(a,b,c)
  x0 = c(1,2)
  plot(0:5, 0:5, type = "n")
  #axis(side = 1)
  #axis(side = 2)
  points(x = x0[1],y= x0[2], col = "green", pch =14 )
  i = 1
  n = 1
  while (i <= 1000) {
    while (n <= 100) {
      cl <- rainbow(100)
      samp = sample(c(1,2,3), 1)
      x = c((to_samp[[samp]][1]), to_samp[[samp]][2])
      new_point = c(((x0[1] + x[1])/2), ((x0[2] + x[2])/2))
      points(x = new_point[1], y = new_point[2], col = cl[n] , pch =14)
      x0 = new_point
      i = i +1
      n = n+1
    }
    samp = sample(c(1,2,3), 1)
    x = c((to_samp[[samp]][1]), to_samp[[samp]][2])
    new_point = c(((x0[1] + x[1])/2), ((x0[2] + x[2])/2))
    points(x = new_point[1], y = new_point[2], cex = 0.2)
    x0 = new_point
    i = i +1
  }
}




challenge_E3 = function(){
  graphics.off()
  a = c(0,0)
  b = c(0,4)
  c = c(4,0)
  d = c(4,4)
  to_samp = list(a,b,c,d)
  x0 = c(2,2)
  plot(0:5, 0:5, type = "n")
  #axis(side = 1)
  #axis(side = 2)
  points(x = x0[1],y= x0[2], col = "green")
  i = 1
  n = 1
  while (i <= 1000) {
    while (n <= 100) {
      cl <- rainbow(100)
      samp = sample(c(1,2,3,4), 1)
      x = c((to_samp[[samp]][1]), to_samp[[samp]][2])
      new_point = c(((x0[1] + x[1])/3), ((x0[2] + x[2])/3))
      points(x = new_point[1], y = new_point[2], col = cl[n])
      x0 = new_point
      i = i +1
      n = n+1
    }
    samp = sample(c(1,2,3,4), 1)
    x = c((to_samp[[samp]][1]), to_samp[[samp]][2])
    new_point = c(((x0[1] + x[1])/2), ((x0[2] + x[2])/2))
    points(x = new_point[1], y = new_point[2], cex = 0.2)
    x0 = new_point
    i = i +1
  }
}


turtle = function(start, direction, len, col = 1){
  direction = direction * (pi/180)
  points(x = start[1], y= start[2], cex = 0.1, col = col)
  new_xy = c(((len * (cos(direction)))+start[1]), ((len * sin(direction))+start[2]))
  x = c(start[1], new_xy[1])
  y = c(start[2], new_xy[2])
  lines(x=x , y = y , col = col)
  return(new_xy)
}
    

elbow = function(start, direction, len){
  direction = direction * (pi/180)
  a = turtle(start, direction, len)
  turtle(a, direction - 45, (0.95*(len)))
}


spiral = function(start, direction, len){
  a = turtle(start, direction, len)
  spiral(a, direction - 45, 0.95*(len))
}


spiral_2 = function(start, direction, len){
  if (len > .5){
    a = turtle(start, direction, len)
    spiral_2(a, (direction)-45, 0.95*(len))
  }
}


tree = function(start, direction, len){
  if (len > .5){
    a = turtle(start, direction, len)
    tree(a, (direction+45), 0.65*(len))
    tree(a, (direction-45), 0.65*(len))
  }
}

fern = function(start, direction, len){
  if (len > 2){
    a = turtle(start, direction, len)
    fern(a, (direction-45), (0.38*(len)))
    fern(a, direction , (0.87*(len)))
  }
}




fern_2 = function(start, direction, len, dir){
  if (len > 1){
    if (dir == -1){
      a = turtle(start, direction, len)
      fern_2(a, (direction-45), (0.38*(len)),-dir)
      fern_2(a, direction , (0.87*(len)), -dir)
    }
    else{
      a = turtle(start, direction, len)
      fern_2(a, (direction+45), (0.38*(len)),-dir)
      fern_2(a, direction , (0.87*(len)), -dir)
    }
  }
}  




challenge_F = function(start, direction, len, dir, col = rainbow(n), n = 1){
  if (len > 0.1){
    if (dir == -1){
      a = turtle(start, direction, len, col = col[n])
      challenge_F(a, (direction-45), (0.38*(len)),-dir, n = n + 1)
      challenge_F(a, direction , (0.87*(len)), -dir, n = n + 1)
    }
    else{
      a = turtle(start, direction, len, col = col[n])
      challenge_F(a, (direction+45), (0.38*(len)),-dir, n = n + 1)
      challenge_F(a, direction , (0.87*(len)), -dir, n = n + 1)
    }
  }
}  



challenge_F2= function(start, direction, len, col = rainbow(n), n = 1){
  if (len > .1){
    a = turtle(start, direction, len, col[n])
    challenge_F2(a, (direction+45), 0.65*(len), n = n +1)
    challenge_F2(a, (direction-45), 0.65*(len), n = n +1)
  }
}





challenge_G <- function(start, direction, len, dir){
  if (len > 1){
    challenge_G1 <- function(start, direction, len, dir){
        new_xy = c(((len * cos(direction))+start[1]), (len * sin(direction)+start[2]))
        x = c(start[1], new_xy[1])
        y = c(start[2], new_xy[2])
        lines(x,y)
        return(new_xy)
     }
      if (dir == -1){ d = direction - pi/4}
      else { d = direction + pi/4}
      a = challenge_G1
      b = a(start, direction,len, dir)
      challenge_G(b, d, .38*len, -dir)
      challenge_G(b, direction, .87*len, -dir)
  }
}





